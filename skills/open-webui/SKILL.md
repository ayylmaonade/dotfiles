---
name: open-webui
description: Comprehensive guide for developing tools, functions, and plugins for Open-WebUI (OWI) LLM Chat UI.
---

# Open-WebUI Development Skill

## Essential Documentation

Before writing any OWI code, consult these primary references:

1. **Functions Documentation** → `references/functions-guide.md`
   - Pipe Functions, Filter Functions, and Action Functions
   - Installation, enabling, and best practices

2. **Tools Documentation** → `references/tools-guide.md`
   - Native Features, Workspace Tools, MCP, OpenAPI Servers
   - Tool calling modes (Default vs Native/Agentic)

3. **Event Emitters** → `references/event-emitters.md`
   - UI integration and real-time updates
   - Event type compatibility matrix

## Core Architecture

### Three Function Types

| Type | Purpose | Execution |
|------|---------|-----------|
| **Pipe** | Custom agents/models or integrations | Standalone execution |
| **Filter** | Modify inputs/outputs at stages | Preprocessing/Streaming/Postprocessing |
| **Action** | Custom chat interface buttons | User-triggered actions |

### Tool Integration Patterns

**Default Mode** (function_calling = "default"):
- Full event emitter support
- Real-time content streaming
- Dynamic message modification
- Interactive experiences

**Native Mode** (Agentic) (function_calling = "native"):
- Limited event emitter support
- Reduced latency
- Autonomous tool selection
- Quality frontier models only

## Event Emitter Compatibility

### Critical: Mode Detection Required

Always detect function calling mode to ensure UI compatibility:

```python
is_native_mode = metadata and metadata.get("params", {}).get("function_calling") == "native"
```

### Most Reliable Event Types (Both Modes)

- `status` - Real-time status updates (✓ COMPATIBLE)
- `citation` - Document citations with metadata (✓ COMPATIBLE)
- `files` - File attachments (✓ COMPATIBLE)
- `chat:message:error` - Error messages (✓ COMPATIBLE)
- `chat:message:follow_ups` - Follow-up suggestions (✓ COMPATIBLE)
- `chat:title` - Dynamic chat title (✓ COMPATIBLE)
- `chat:tags` - Chat tags management (✓ COMPATIBLE)
- `notification` - Toast notifications (✓ COMPATIBLE)
- `confirmation` - User confirmations (✓ COMPATIBLE)
- `input` - User input requests (✓ COMPATIBLE)
- `execute` - Dynamic code execution (✓ COMPATIBLE)

### Event Types: Default Mode Only (Native Mode INCOMPATIBLE)

- `message` - Content updates (BROKEN - causes flickering)
- `chat:completion` - Limited support
- `chat:message:delta` - BROKEN
- `chat:message` - BROKEN
- `replace` - BROKEN

## Key Implementation Patterns

### Universal Mode-Safe Tool

```python
async def universal_tool(self, prompt: str, __event_emitter__=None, metadata=None):
    is_native_mode = metadata and metadata.get("params", {}).get("function_calling") == "native"

    if __event_emitter__:
        if is_native_mode:
            await __event_emitter__({
                "type": "status",
                "data": {"description": "Native mode processing...", "done": False}
            })
        else:
            await __event_emitter__({
                "type": "message",
                "data": {"content": "Default mode full streaming..."}
            })

    # Tool logic here

    if __event_emitter__:
        await __event_emitter__({
            "type": "status",
            "data": {"description": "Completed", "done": True}
        })

    return "Tool execution completed"
```

### Rich UI Embedding

```python
from fastapi.responses import HTMLResponse

async def visualize_data(self, data: str, __event_emitter__=None):
    html_content = """
    <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>
    <div id="chart" style="width:100%;height:400px;"></div>
    <script>Plotly.newPlot('chart', [{y: [1, 2, 3], type: 'scatter'}]);</script>
    """

    return HTMLResponse(content=html_content, headers={"Content-Disposition": "inline"})
```

## Development Checklist

Before deployment:

- [ ] Read primary documentation references
- [ ] Validate code against documented specifications
- [ ] Test in Default Mode first (full compatibility)
- [ ] Implement mode detection in all tools
- [ ] Only use status/citation/event types compatible with Native Mode
- [ ] Verify HTML embedding works with browser security settings
- [ ] Enable only trusted Functions/Tools
- [ ] Test with target function calling mode

## References

- `references/functions-guide.md` - Comprehensive Functions & Tools guide
- `references/event-emitters.md` - Complete Event emitter documentation and examples
- `references/implementation-patterns.md` - Code patterns and API patterns
- `references/troubleshooting.md` - Common issues and solutions
