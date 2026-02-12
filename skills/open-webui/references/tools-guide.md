# Tools Documentation

**Reference**: https://docs.openwebui.com/features/plugin/tools/

## Overview

Tools extend LLM capabilities beyond text generation by integrating external functionality. They allow the model to perform web searches, generate images, access memory, use RAG, and execute code.

## Tooling Types

### Native Features

Built-in capabilities provided by Open WebUI:
- **Web Search**: Real-time web searching capabilities
- **Image Generation**: Create images from text prompts
- **Code Execution**: Run code snippets securely
- **File Operations**: Read/write files
- **Memory**: Store and retrieve conversation context

### Workspace Tools

User-defined tools hosted within Open WebUI:
- Located in `.open-webui/tools/`
- Can be Python scripts, Docker containers, or web services
- Accessed via `workspace://` protocol

### MCP (Model Context Protocol)

- **Definition**: Protocol for connecting LLMs to external data sources
- **Function**: Enables structured access to external information
- **Use Cases**: Database queries, API integrations, file system access
- **Status**: Integration with OWI in development

### OpenAPI Servers

- **Definition**: Tools exposed via OpenAPI/REST API endpoints
- **Function**: External web services that follow OpenAPI specifications
- **Integration**: Automatically discovers and connects to OpenAPI endpoints
- **Use Cases**: Enterprise systems, existing APIs, third-party services

## Tool Calling Modes

### Default Mode (function_calling = "default")

**Characteristics**:
- Full Open WebUI tool processing pipeline
- Complete event emitter support
- Native mode bypasses custom tool processing
- Ideal for complex workflows and interactions

**Pros**:
- Full event emitter compatibility
- Real-time streaming support
- Interactive experiences
- Custom UI integration

**Cons**:
- Slightly higher latency
- More complex implementation

### Native Mode (Agentic Mode) (function_calling = "native")

**Characteristics**:
- Native function calling (LLM-driven)
- Bypasses Open WebUI custom tool processing
- Reduced latency
- Quality frontier models required (GPT-5, Claude 4.5+, Gemini 3+, MiniMax M2.1)

**Pros**:
- Reduced latency
- Autonomous tool selection
- Simpler implementation

**Cons**:
- Limited event emitter support
- Native mode emits repeated chat:completion events
- Tool-emitted updates can flicker/disappear

**Important**: Many event types incompatible in Native Mode

## System Tools

Built-in system-level tools always available:
- `web-search`: Search the web for information
- `search`: General search functionality
- `image-generation`: Create images from text
- `execute`: Execute code safely
- `code-interpreter`: Advanced code execution environment

## Installation & Management

### Enabling Tools

1. **Administrator Level**:
   - Admin Panel > Settings > Models > Model Specific Settings
   - Advanced Parameters > Tools
   - Enable desired tools globally

2. **Per-Request Basis**:
   - Chat Controls > Advanced Params > Tools
   - Enable tools for specific conversations

### Installing New Tools

**Workspace Tools**:
1. Place tool files in `.open-webui/tools/`
2. Follow tool format specifications
3. Restart Open WebUI
4. Tools appear automatically

**Custom Tools** (Python):
1. Create tool implementation in `.open-webui/tools/`
2. Define tool schema in `tools.json`
3. Restart Open WebUI
4. Enable in tool settings

## Optional Arguments

Tools receive these arguments for interaction:

- `__event_emitter__`: Emit events for UI updates
- `__event_call__`: Same as event_emitter for user interactions
- `user`: Dictionary with user information and UserValves
- `metadata`: Dictionary with chat metadata
- `messages`: List of previous messages
- `files`: Attached files
- `model`: Dictionary with model information
- `__oauth_token__`: User's valid, automatically refreshed OAuth token

## Best Practices

1. **Mode Selection**:
   - Use Default Mode for interactive/experience tools
   - Use Native Mode for simple data retrieval/computation
   - Always implement mode detection in tools

2. **Event Emitter Usage**:
   - Check function calling mode before using event emitters
   - Prefer status events (always compatible)
   - Avoid message events in Native Mode
   - Use compatible event types only

3. **Performance**:
   - Keep execution times reasonable
   - Implement timeouts for long-running operations
   - Cache frequently accessed data

4. **Security**:
   - Validate all inputs
   - Sanitize outputs
   - Use OAuth token for API calls
   - Follow OWI security guidelines

5. **Error Handling**:
   - Provide clear error messages
   - Handle edge cases gracefully
   - Log errors appropriately

6. **User Experience**:
   - Provide real-time status updates
   - Show progress indicators
   - Handle timeouts appropriately

## Security Notes

1. Only install Functions/Tools from trusted sources
2. These execute on the server
3. Careful review required before deployment
4. Follow OWI security guidelines
5. Validate all inputs and sanitize outputs
6. Use OAuth tokens for external API calls
7. Consider tool execution risks (code execution, network calls)
