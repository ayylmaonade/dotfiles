# Troubleshooting Guide

**Reference**: Common issues and solutions for Open-WebUI development

## Overview

This guide helps troubleshoot common issues encountered when developing Open-WebUI tools and functions. Focus on understanding the root causes and applying appropriate solutions.

## Event Emitter Issues

### Native Mode Conflicts

#### Symptoms:
- Tool-emitted messages appear briefly then disappear
- Content flickers during tool execution
- `message` or `replace` events seem to be ignored
- Status updates work but content updates don't persist

#### Root Cause:
Native mode bypasses Open WebUI's custom tool processing pipeline and emits repeated `chat:completion` events that replace message content.

#### Solutions:

1. **Switch to Default Mode**
   - Change function calling mode to "default"
   - More reliable event emitter support

2. **Use Only Compatible Event Types**
   - Use `status` events for progress updates (always compatible)
   - Avoid `message`, `chat:message:delta`, `chat:message`, `replace` events
   - Use citation, notification, confirmation events instead

3. **Implement Mode Detection**
   ```python
   async def universal_tool(self, prompt: str, __event_emitter__=None, metadata=None):
       is_native_mode = metadata and metadata.get("params", {}).get("function_calling") == "native"

       if __event_emitter__:
           if is_native_mode:
               # Native mode: Limited support
               await __event_emitter__({
                   "type": "status",
                   "data": {"description": "Native mode...", "done": False}
               })
           else:
               # Default mode: Full support
               await __event_emitter__({
                   "type": "message",
                   "data": {"content": "Processing..."}
               })
   ```

4. **Consider Hybrid Approaches**
   - Use compatible events only in Native Mode
   - Keep tool logic simple and deterministic

### Default Mode Issues

#### Symptoms:
- Events not firing at all
- Event emission is too slow
- Performance degradation

#### Root Cause:
May be related to event emitter configuration or implementation bugs.

#### Solutions:

1. **Verify Event Emitter Implementation**
   - Check that `__event_emitter__` is passed as parameter
   - Ensure await is used for async events
   - Verify event structure matches documentation

2. **Check Event Emitter Configuration**
   - Ensure tool is properly configured
   - Verify Open WebUI settings
   - Check for any blocking code

3. **Performance Optimization**
   ```python
   # Use async properly
   async def efficient_tool(self, prompt: str, __event_emitter__=None):
       await __event_emitter__({
           "type": "status",
           "data": {"description": "Processing...", "done": False}
       })

       # Process data in parallel if possible
       results = await asyncio.gather(
           self._process_data1(prompt),
           self._process_data2(prompt)
       )

       await __event_emitter__({
           "type": "status",
           "data": {"description": "Complete", "done": True}
       })
   ```

## Tool Execution Issues

### Timeouts

#### Symptoms:
- Tool execution hangs indefinitely
- Timeout errors
- User sees spinner forever

#### Root Cause:
Tool processing is blocking or taking too long.

#### Solutions:

1. **Implement Timeout**
   ```python
   async def timeout_tool(self, prompt: str, __event_emitter__=None):
       try:
           # Set timeout
           await asyncio.wait_for(
               self._process_long_task(prompt),
               timeout=30
           )

           return "Task completed"

       except asyncio.TimeoutError:
           if __event_emitter__:
               await __event_emitter__({
                   "type": "status",
                   "data": {
                       "description": "Task timeout",
                       "done": True
                   }
               })

               await __event_emitter__({
                   "type": "chat:message:error",
                   "data": {
                       "message": "Task timed out after 30 seconds"
                   }
               })

           return "Task timed out"
   ```

2. **Use Breakpoint Callback**
   - Implement stop functionality
   - Add progress indicators
   - Use short processing intervals

3. **Optimize Processing**
   - Break large tasks into smaller chunks
   - Use background processing
   - Cache frequently accessed data

### Errors Not Displayed

#### Symptoms:
- Tool fails silently
- No error message shown to user
- Chat interface looks normal

#### Root Cause:
Error handling not implemented properly or events not configured for error display.

#### Solutions:

1. **Implement Error Handling**
   ```python
   async def error_handling_tool(self, prompt: str, __event_emitter__=None):
       try:
           result = await self._process(prompt)

           if __event_emitter__:
               await __event_emitter__({
                   "type": "status",
                   "data": {
                       "description": "Success",
                       "done": True
                   }
               })

           return result

       except Exception as e:
           # Always emit error status
           if __event_emitter__:
               await __event_emitter__({
                   "type": "status",
                   "data": {
                       "description": "Error",
                       "done": True
                   }
               })

               # Display error message
               await __event_emitter__({
                   "type": "chat:message:error",
                   "data": {
                       "message": f"Error: {str(e)}"
                   }
               })

           raise
   ```

2. **Use Structured Error Events**
   ```python
   await __event_emitter__({
       "type": "status",
       "data": {"description": "Error occurred", "done": True}
   })

   await __event_emitter__({
       "type": "chat:message:error",
       "data": {
           "message": "Detailed error description",
           "details": {
               "error_type": "ValueError",
               "context": "Invalid input provided"
           }
       }
   })
   ```

## UI Integration Issues

### HTML Not Displaying

#### Symptoms:
- HTML content not rendering
- Empty container
- Raw HTML code visible

#### Root Cause:
HTML not formatted correctly, CORS issues, or server response misconfiguration.

#### Solutions:

1. **Verify HTML Structure**
   ```python
   # Ensure proper HTML structure
   html_content = """
   <!DOCTYPE html>
   <html>
   <head>
       <title>Tool</title>
   </head>
   <body>
       <div id="content"></div>
   </body>
   </html>
   """

   return HTMLResponse(
       content=html_content,
       headers={"Content-Disposition": "inline"}
   )
   ```

2. **Check CORS Headers**
   ```javascript
   const app = express();
   app.use(cors());

   app.get('/tools/dashboard', (req, res) => {
       res.set({
           'Content-Disposition': 'inline',
           'Access-Control-Expose-Headers': 'Content-Disposition'
       });
       res.send(html);
   });
   ```

3. **Test in Default Mode**
   - HTML display often works better in Default Mode
   - Test compatibility with Native Mode

### Content Flickering

#### Symptoms:
- Content appears then disappears
- Multiple rapid updates
- Unstable UI behavior

#### Root Cause:
Event emission timing, mode conflicts, or competing event sources.

#### Solutions:

1. **Use Compatible Events**
   - Avoid `message` and `replace` events
   - Use `status` events for updates
   - Emit events in sequence

2. **Implement Proper Timing**
   ```python
   # Emit events in sequence
   await __event_emitter__({
       "type": "status",
       "data": {"description": "Phase 1", "done": False}
   })

   # Process data...

   await __event_emitter__({
       "type": "status",
       "data": {"description": "Phase 2", "done": False}
   })

   # Process data...

   await __event_emitter__({
       "type": "status",
       "data": {"description": "Complete", "done": True}
   })
   ```

3. **Check Mode Compatibility**
   - Test in both Default and Native modes
   - Use mode detection
   - Adjust event types accordingly

## Mode-Related Issues

### Mode Detection Not Working

#### Symptoms:
- Tool doesn't adapt to mode
- Behavior inconsistent
- Events not compatible

#### Root Cause:
Mode detection logic incorrect or metadata not properly passed.

#### Solutions:

1. **Verify Mode Detection**
   ```python
   async def test_mode_detection(self, __event_emitter__=None, metadata=None):
       if __event_emitter__:
           await __event_emitter__({
               "type": "status",
               "data": {
                   "description": f"Mode: {metadata.get('params', {}).get('function_calling', 'unknown')}",
                   "done": False
               }
           })
   ```

2. **Check Metadata Structure**
   ```python
   # Verify metadata structure
   if metadata and "params" in metadata:
       function_calling = metadata["params"].get("function_calling")
       print(f"Function calling mode: {function_calling}")
   else:
       print("No metadata found")
   ```

3. **Handle Missing Metadata**
   ```python
   async def safe_tool(self, __event_emitter__=None, metadata=None):
       # Default to safe behavior if metadata missing
       is_native_mode = metadata and metadata.get("params", {}).get("function_calling") == "native"

       # Use compatible events regardless of mode
       await __event_emitter__({
           "type": "status",
           "data": {
               "description": "Processing",
               "done": False
           }
       })
   ```

## Performance Issues

### Slow Tool Execution

#### Symptoms:
- Long processing time
- Poor user experience
- High latency

#### Root Cause:
Inefficient processing, blocking operations, or lack of async support.

#### Solutions:

1. **Use Async Processing**
   ```python
   # Avoid blocking operations
   async def non_blocking_tool(self, prompt: str, __event_emitter__=None):
       # Use async I/O operations
       async with httpx.AsyncClient() as client:
           response = await client.get(url)

       # Process in parallel
       results = await asyncio.gather(
           self._process1(prompt),
           self._process2(prompt)
       )

       return results
   ```

2. **Optimize Data Processing**
   ```python
   # Use efficient data structures
   import asyncio

   async def chunked_processing(self, prompt: str, __event_emitter__=None):
       chunks = self._split_into_chunks(prompt, chunk_size=1000)

       results = []
       for i, chunk in enumerate(chunks):
           if __event_emitter__:
               await __event_emitter__({
                   "type": "status",
                   "data": {
                       "description": f"Processing chunk {i+1}/{len(chunks)}",
                       "done": False
                   }
               })

           result = await self._process_chunk(chunk)
           results.append(result)

       return results
   ```

3. **Implement Caching**
   ```python
   from functools import lru_cache
   import hashlib

   class CachedTool:
       @lru_cache(maxsize=100)
       async def execute(self, prompt: str):
           # Hash the prompt to create cache key
           cache_key = hashlib.md5(prompt.encode()).hexdigest()

           # Check cache first
           if self._check_cache(cache_key):
               return self._get_from_cache(cache_key)

           # Process data
           result = await self._process(prompt)

           # Cache result
           self._save_to_cache(cache_key, result)

           return result
   ```

## Security Issues

### Unauthorized Access

#### Symptoms:
- Tools executing without permissions
- Privilege escalation
- Data leakage

#### Root Cause:
Missing authentication checks or authorization.

#### Solutions:

1. **Implement Authentication**
   ```python
   async def secure_tool(self, prompt: str, user_info=None):
       if not user_info:
           raise ValueError("Unauthorized access")

       # Check user permissions
       if not self._has_permission(user_info["user_id"], "tool_access"):
           raise ValueError("Insufficient permissions")

       # Check OAuth token
       if "oauth_token" not in user_info:
           raise ValueError("Missing OAuth token")

       # Use token for API calls
       api_response = await self._call_api(
           user_info["oauth_token"],
           prompt
       )

       return api_response
   ```

2. **Validate Inputs**
   ```python
   async def input_validation_tool(self, prompt: str, __event_emitter__=None):
       # Length check
       if len(prompt) < 10:
           raise ValueError("Input too short")

       if len(prompt) > 10000:
           raise ValueError("Input too long")

       # Character whitelist
       allowed_chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 .,!?;:-_"
       if not all(c in allowed_chars for c in prompt):
           raise ValueError("Invalid characters detected")

       # Pattern validation
       if not self._validate_pattern(prompt):
           raise ValueError("Invalid input format")

       return await self._process(prompt)
   ```

## Debugging Techniques

### Logging Implementation

```python
import logging

class DebugTool:
    def __init__(self):
        self.logger = logging.getLogger(__name__)

    async def execute(self, prompt: str, __event_emitter__=None, metadata=None):
        # Log input
        self.logger.info(f"Input: {prompt}")

        # Log mode
        mode = metadata.get("params", {}).get("function_calling") if metadata else "unknown"
        self.logger.info(f"Mode: {mode}")

        try:
            # Processing
            result = await self._process(prompt)

            # Log result
            self.logger.info(f"Result: {result}")

            return result

        except Exception as e:
            self.logger.error(f"Error: {str(e)}", exc_info=True)
            raise
```

### Event Trace Logging

```python
async def traced_tool(self, prompt: str, __event_emitter__=None):
    if __event_emitter__:
        await __event_emitter__({
            "type": "status",
            "data": {
                "description": "Step 1: Starting",
                "done": False
            }
        })

    # Processing...

    if __event_emitter__:
        await __event_emitter__({
            "type": "status",
            "data": {
                "description": "Step 2: Processing",
                "done": False
            }
        })

    # Processing...

    if __event_emitter__:
        await __event_emitter__({
            "type": "status",
            "data": {
                "description": "Step 3: Complete",
                "done": True
            }
        })
```

## Testing Checklist

### Before Deployment

- [ ] Test in Default Mode
- [ ] Test in Native Mode
- [ ] Verify mode detection works correctly
- [ ] Test all event types for compatibility
- [ ] Verify error handling displays properly
- [ ] Test HTML embedding in both modes
- [ ] Test timeout behavior
- [ ] Test performance with realistic inputs
- [ ] Verify security measures work
- [ ] Check CORS configuration
- [ ] Test with various user inputs
- [ ] Test edge cases
- [ ] Test concurrent executions
- [ ] Verify OAuth token handling

### Common Quick Tests

```python
# Quick mode test
async def quick_test(self, __event_emitter__=None, metadata=None):
    mode = metadata.get("params", {}).get("function_calling") if metadata else "unknown"

    # Test status event (always compatible)
    await __event_emitter__({
        "type": "status",
        "data": {"description": f"Mode test: {mode}", "done": True}
    })

    # Test notification event (always compatible)
    await __event_emitter__({
        "type": "notification",
        "data": {"message": "Quick test passed"}
    })

    return "Test complete"
```

## Getting Help

### Documentation
- Primary: https://docs.openwebui.com
- Functions: https://docs.openwebui.com/features/plugin/functions/
- Tools: https://docs.openwebui.com/features/plugin/tools/

### Debugging Steps
1. Identify symptoms
2. Check Open WebUI logs
3. Verify tool implementation
4. Test in both modes
5. Review event compatibility
6. Check security settings
7. Test with simple examples

### Common Error Codes
- **500**: Internal server error
- **400**: Invalid input or parameters
- **401**: Unauthorized access
- **403**: Permission denied
- **404**: Tool not found
- **429**: Rate limit exceeded
- **503**: Service unavailable

## Summary

Troubleshooting Open-WebUI tools requires:
- Understanding the function calling modes
- Proper event emitter usage
- Comprehensive error handling
- Performance optimization
- Security considerations
- Thorough testing in both modes
