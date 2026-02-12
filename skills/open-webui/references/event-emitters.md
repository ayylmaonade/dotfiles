# Event Emitters & UI Changes Documentation

**Reference**: https://docs.openwebui.com/features/plugin/functions/filter/

## Overview

Event Emitters are used to add additional information to the chat interface. They allow tools to:

- Append content to the chat during tool execution
- Display real-time status updates
- Show citations and sources
- Embed rich UI elements
- Create interactive experiences

## Critical: Function Calling Mode Compatibility

**IMPORTANT**: Event Emitter behavior differs significantly between function calling modes.

### Default Mode (function_calling = "default")
- **Full event emitter support**
- All event types working correctly
- Ideal for complex, interactive tools

### Native Mode (Agentic Mode) (function_calling = "native")
- **Limited event emitter support**
- Many event types broken
- Native function calling bypasses Open WebUI's custom tool processing pipeline
- Tool-emitted updates can flicker/disappear

## Optional Arguments for Tools

Tools can use these optional arguments to interact with UI:

```python
async def my_tool(self, prompt: str, __event_emitter__=None, metadata=None):
    """
    prompt: Input prompt from user
    __event_emitter__: Emit events for UI updates
    __event_call__: Same as event_emitter for user interactions
    user: Dictionary with user information and UserValves
    metadata: Dictionary with chat metadata
    messages: List of previous messages
    files: Attached files
    model: Dictionary with model information
    __oauth_token__: User's valid, automatically refreshed OAuth token
    """
    pass
```

## Event Types Reference

### Status Events (MOST RELIABLE - FULLY COMPATIBLE)

Status events show real-time progress in the chat interface.

```python
await __event_emitter__({
    "type": "status",
    "data": {
        "description": "Message that shows up in the chat",
        "done": False,
        "hidden": False
    }
})
```

**Parameters**:
- `description` (str): Message to display in chat
- `done` (bool): Mark as complete when True
- `hidden` (bool): Hide from UI (default: False)

**Usage Example**:
```python
async def processing_tool(self, prompt: str, __event_emitter__=None):
    if __event_emitter__:
        await __event_emitter__({
            "type": "status",
            "data": {"description": "Starting processing...", "done": False}
        })

    # Processing logic...

    if __event_emitter__:
        await __event_emitter__({
            "type": "status",
            "data": {"description": "Processing complete!", "done": True}
        })

    return "Done"
```

### Citation Events (FULLY COMPATIBLE)

Citation events display document citations with metadata.

```python
await __event_emitter__({
    "type": "citation",
    "data": {
        "document": [content],
        "metadata": [
            {
                "date_accessed": datetime.now().isoformat(),
                "source": title,
                "author": "Author Name",
                "publication_date": "2024-01-01",
                "url": "https://source-url.com"
            }
        ],
        "source": {"name": title, "url": url}
    }
})
```

**Parameters**:
- `document` (str): Document content
- `metadata` (list): Document metadata objects
- `source` (dict): Source information

**Usage Example**:
```python
from datetime import datetime

async def search_and_cite(self, query: str, __event_emitter__=None):
    results = search_database(query)

    if __event_emitter__:
        for result in results:
            await __event_emitter__({
                "type": "citation",
                "data": {
                    "document": result.content,
                    "metadata": [{
                        "date_accessed": datetime.now().isoformat(),
                        "source": result.title,
                        "author": result.author,
                        "publication_date": result.date,
                        "url": result.url
                    }],
                    "source": {
                        "name": result.title,
                        "url": result.url
                    }
                }
            })

    return f"Found {len(results)} results"
```

### Other Compatible Event Types (Both Modes)

These event types are compatible in both Default and Native modes:

```python
# Notification: Toast notifications
await __event_emitter__({
    "type": "notification",
    "data": {"message": "Action completed successfully"}
})

# Files: File attachments
await __event_emitter__({
    "type": "files",
    "data": {"files": [file_path]}
})

# chat:message:files: File attachments
await __event_emitter__({
    "type": "chat:message:files",
    "data": {"files": [file_path]}
})

# chat:message:follow_ups: Follow-up suggestions
await __event_emitter__({
    "type": "chat:message:follow_ups",
    "data": ["Follow-up 1", "Follow-up 2", "Follow-up 3"]
})

# chat:title: Update chat title dynamically
await __event_emitter__({
    "type": "chat:title",
    "data": {"title": "New Dynamic Title"}
})

# chat:tags: Manage chat tags
await __event_emitter__({
    "type": "chat:tags",
    "data": {"tags": ["tag1", "tag2"]}
})

# chat:message:error: Display error messages
await __event_emitter__({
    "type": "chat:message:error",
    "data": {"message": "Error description here"}
})

# confirmation: Request user confirmations
await __event_emitter__({
    "type": "confirmation",
    "data": {
        "message": "Are you sure?",
        "callback": "confirm_action"
    }
})

# input: Request user input
await __event_emitter__({
    "type": "input",
    "data": {
        "message": "Please provide input",
        "callback": "handle_input"
    }
})

# execute: Execute code dynamically
await __event_emitter__({
    "type": "execute",
    "data": {
        "code": "print('Hello World')",
        "callback": "handle_execute"
    }
})

# chat:tasks:cancel: Cancel ongoing tasks
await __event_emitter__({
    "type": "chat:tasks:cancel",
    "data": {"task_id": "task123"}
})
```

### Message Events (DEFAULT MODE ONLY - INCOMPATIBLE WITH NATIVE)

These events work in Default Mode but are **BROKEN** in Native Mode:

```python
# message: Append/replace content in chat
await __event_emitter__({
    "type": "message",
    "data": {"content": "This content will be appended/replaced"}
})

# chat:completion: Limited support
await __event_emitter__({
    "type": "chat:completion",
    "data": {"content": "Completion content"}
})

# chat:message:delta: BROKEN in Native Mode
await __event_emitter__({
    "type": "chat:message:delta",
    "data": {"content": "Delta content"}
})

# chat:message: BROKEN in Native Mode
await __event_emitter__({
    "type": "chat:message",
    "data": {"content": "Full message content"}
})

# replace: BROKEN in Native Mode
await __event_emitter__({
    "type": "replace",
    "data": {"content": "Replace message content"}
})
```

**Why they break in Native Mode**:
- Native function calling emits repeated `chat:completion` events with full content snapshots
- These events completely replace message content
- Tool-emitted updates flicker and disappear
- Native mode bypasses Open WebUI's custom tool processing pipeline

## Event Type Compatibility Matrix

| Event Type | Default Mode | Native Mode | Status |
|-----------|--------------|-------------|---------|
| `status` | Full | Identical | ✅ COMPATIBLE |
| `message` | Full | BROKEN | ❌ INCOMPATIBLE |
| `chat:completion` | Full | LIMITED | ⚠️ PARTIALLY COMPATIBLE |
| `chat:message:delta` | Full | BROKEN | ❌ INCOMPATIBLE |
| `chat:message` | Full | BROKEN | ❌ INCOMPATIBLE |
| `replace` | Full | BROKEN | ❌ INCOMPATIBLE |
| `files` | Full | Identical | ✅ COMPATIBLE |
| `chat:message:files` | Full | Identical | ✅ COMPATIBLE |
| `chat:message:error` | Full | Identical | ✅ COMPATIBLE |
| `chat:message:follow_ups` | Full | Identical | ✅ COMPATIBLE |
| `chat:title` | Full | Identical | ✅ COMPATIBLE |
| `chat:tags` | Full | Identical | ✅ COMPATIBLE |
| `citation` | Full | Identical | ✅ COMPATIBLE |
| `notification` | Full | Identical | ✅ COMPATIBLE |
| `confirmation` | Full | Identical | ✅ COMPATIBLE |
| `input` | Full | Identical | ✅ COMPATIBLE |
| `execute` | Full | Identical | ✅ COMPATIBLE |
| `chat:tasks:cancel` | Full | Identical | ✅ COMPATIBLE |

## Rich UI Element Embedding

Both External and Built-In Tools support rich HTML content embedding via `HTMLResponse`.

### Basic HTML Embedding

```python
from fastapi.responses import HTMLResponse

async def create_visualization_tool(self, data: str, __event_emitter__=None):
    html_content = """
    <!DOCTYPE html>
    <html>
    <head>
        <title>Data Visualization</title>
        <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>
    </head>
    <body>
        <div id="chart" style="width:100%;height:400px;"></div>
        <script>
            Plotly.newPlot('chart', [{
                y: [1, 2, 3, 4],
                type: 'scatter'
            }]);
        </script>
    </body>
    </html>
    """

    headers = {"Content-Disposition": "inline"}
    return HTMLResponse(content=html_content, headers=headers)
```

### Features

- **Auto-resizing**: Content automatically adjusts height to fit container
- **Cross-origin communication**: Safe message passing between iframe and parent
- **Configurable security**: Sandbox restrictions via UI settings
- **No external dependencies**: Only requires internet connection for CDNs

### Advanced Usage

```python
async def interactive_dashboard(self, data: str, __event_emitter__=None):
    html_content = """
    <!DOCTYPE html>
    <html>
    <head>
        <title>Interactive Dashboard</title>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <style>
            .chart-container {
                height: 300px;
                margin: 10px 0;
            }
        </style>
    </head>
    <body>
        <div class="chart-container">
            <canvas id="chart1"></canvas>
        </div>
        <div class="chart-container">
            <canvas id="chart2"></canvas>
        </div>
        <script>
            // Chart 1
            new Chart(document.getElementById('chart1'), {
                type: 'bar',
                data: {
                    labels: ['Jan', 'Feb', 'Mar', 'Apr'],
                    datasets: [{
                        label: 'Data 1',
                        data: [12, 19, 3, 5]
                    }]
                }
            });

            // Chart 2
            new Chart(document.getElementById('chart2'), {
                type: 'line',
                data: {
                    labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
                    datasets: [{
                        label: 'Data 2',
                        data: [8, 15, 22, 18, 25]
                    }]
                }
            });

            // Interactive elements
            document.getElementById('chart1').onclick = function() {
                alert('Chart clicked!');
            };
        </script>
    </body>
    </html>
    """

    return HTMLResponse(content=html_content, headers={"Content-Disposition": "inline"})
```

## CORS Configuration for Direct Tools

For browser-based tools with CORS, ensure proper headers:

```javascript
const app = express();

app.use(cors());

app.get('/tools/dashboard', (req, res) => {
    let html = `
    <!DOCTYPE html>
    <html>
    <head>
        <title>Dashboard</title>
    </head>
    <body>
        <h1>Interactive Dashboard</h1>
        <div id="content"></div>
        <script>
            fetch('/api/data')
                .then(response => response.json())
                .then(data => {
                    document.getElementById('content').textContent = JSON.stringify(data);
                });
        </script>
    </body>
    </html>
    `;

    res.set({
        'Content-Disposition': 'inline',
        'Access-Control-Expose-Headers': 'Content-Disposition'
    });

    res.send(html);
});
```

## Best Practices for Mode Selection

### Use Default Mode When:

✅ You need real-time content streaming or live updates
✅ You need dynamic message modification
✅ Building interactive experiences, dashboards, or multi-step workflows
✅ You need full event emitter functionality
✅ Tool requires extensive UI updates during execution

### Use Native Mode (Agentic Mode) When:

✅ You have a quality frontier model (GPT-5, Claude 4.5+, Gemini 3+, MiniMax M2.1)
✅ You need reduced latency and autonomous tool selection
✅ Tool is primarily for simple data retrieval or computation
✅ You don't need complex message streaming or modifications
✅ Event emitter functionality is limited or unnecessary

## Mode-Safe Implementation Pattern

### Universal Tool with Mode Detection

```python
async def universal_tool(self, prompt: str, __event_emitter__=None, metadata=None):
    """
    Universal tool that works correctly in both Default and Native modes.
    """
    is_native_mode = metadata and metadata.get("params", {}).get("function_calling") == "native"

    if __event_emitter__:
        # Always use compatible event type
        if is_native_mode:
            # Native mode: Use status event only
            await __event_emitter__({
                "type": "status",
                "data": {
                    "description": "Processing in native mode (limited event support)...",
                    "done": False
                }
            })
        else:
            # Default mode: Can use full event emitter
            await __event_emitter__({
                "type": "message",
                "data": {"content": "Processing with full event support..."}
            })

    # Tool logic here...
    await process_data(prompt)

    if __event_emitter__:
        await __event_emitter__({
            "type": "status",
            "data": {"description": "Completed successfully", "done": True}
        })

    return "Tool execution completed"
```

### Mode-Safe Implementation Checklist

- [ ] Implement mode detection at function start
- [ ] Use only compatible event types
- [ ] Test in both Default and Native modes
- [ ] Avoid message events in Native Mode
- [ ] Use status events for progress updates (always compatible)
- [ ] Provide clear error messages in both modes
- [ ] Consider hybrid approaches using compatible events only

## Troubleshooting Event Emitter Issues

### Symptoms of Native Mode Conflicts

❌ Tool-emitted messages appear briefly then disappear
❌ Content flickers during tool execution
❌ message or replace events seem to be ignored
❌ Status updates work but content updates don't persist
❌ Mixed content during streaming

### Solutions

1. **Switch to Default Mode** (if possible)
2. **Use only compatible event types** in Native Mode
3. **Implement mode detection** in your tool code
4. **Consider hybrid approaches** using compatible events only
5. **Test thoroughly** in both modes before deployment

### Debugging Tips

```python
async def debug_tool(self, prompt: str, __event_emitter__=None, metadata=None):
    print(f"Mode: {metadata.get('params', {}).get('function_calling')}")

    if __event_emitter__:
        await __event_emitter__({
            "type": "status",
            "data": {
                "description": f"Debug: Mode={metadata.get('params', {}).get('function_calling')}",
                "done": False
            }
        })

    # Test event types
    await __event_emitter__({"type": "notification", "data": {"message": "Test"}})

    # ...
```

## Function Calling Mode Configuration

### Administrator Level

1. Admin Panel → Settings → Models → Model Specific Settings
2. Advanced Parameters → Function Calling
3. Select "default" or "native"

### Per-Request Basis

1. Chat Controls → Advanced Params → Function Calling
2. Select "default" or "native"
3. Applies to current conversation only

## Summary

Event Emitters provide powerful UI integration capabilities, but their behavior is fundamentally tied to the function calling mode. Always:
- Detect the mode before using event emitters
- Use only compatible event types
- Test in both modes
- Provide fallback behavior for Native Mode
- Prioritize status events for progress updates
- Implement robust error handling
