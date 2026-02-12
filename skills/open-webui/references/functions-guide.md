# Functions Documentation

**Reference**: https://docs.openwebui.com/features/plugin/functions/

## Overview

Functions are built-in plugins that run within the Open WebUI environment using pure Python. They extend OWI capabilities by creating custom agents, modifying chat flows, or adding interface elements.

## Three Function Types

### 1. Pipe Functions

**Purpose**: Create custom agents/models or integrations that appear as standalone models.

**Key Characteristics**:
- Execute independently
- Return text to the chat interface
- Can wrap any model (OpenAI, Claude, etc.)
- Appear as new options in model selection

**Common Use Cases**:
- Wrapping custom AI models
- Creating specialized chatbots
- Building integration endpoints
- Adding privacy-gated models

### 2. Filter Functions

**Purpose**: Modify inputs and outputs at different stages of the LLM workflow.

**Three Execution Phases**:

1. **Inlet** (Input Pre-processing)
   - Runs before message enters LLM
   - Can modify prompts, add context, validate input
   - Example: Inject system prompts, sanitize content, add metadata

2. **Stream** (Real-time Streaming Interception)
   - Runs during token-by-token generation
   - Can modify streaming output, add live updates
   - Example: Format code in real-time, add markdown formatting

3. **Outlet** (Output Post-processing)
   - Runs after LLM generates complete message
   - Can modify final output, format results
   - Example: Clean up JSON responses, add citations

**Configuration Options**:
- **Valves**: Configuration parameters exposed to users
- **Priority**: Execution order (lower number = higher priority)
- **Toggleable**: Can be enabled/disabled by users
- **Always-on**: Runs automatically
- **Model-specific**: Can be scoped to specific models

**Common Use Cases**:
- Code formatters and linters
- Language translation
- Security filtering
- Documentation generation
- Response formatting

### 3. Action Functions

**Purpose**: Add custom buttons to the chat interface.

**Key Characteristics**:
- User-triggered buttons
- Accept arguments from user input
- Return actions to trigger other functions or tools
- Can display confirmations or input prompts

**Common Use Cases**:
- Code execution triggers
- Document generation
- Custom workflows
- User confirmation dialogs
- Tool invocation shortcuts

## Installation & Configuration

### Enabling Functions

1. Go to Settings > Settings > Functions
2. Enable desired functions
3. Configure valves and parameters
4. Save and restart (if required)

### Permissions

Functions execute with the API server's privileges, so:
- Review function code carefully
- Only install trusted functions
- Be aware of potential security implications
- Follow OWI security guidelines

## Best Practices

1. **Keep functions pure Python**: Use standard Python libraries and OWI APIs only
2. **Validate all inputs**: Never trust user input without validation
3. **Error handling**: Always include try-catch blocks and proper error reporting
4. **Performance**: Keep execution time reasonable (<30 seconds)
5. **Testing**: Test with various inputs and edge cases
6. **Documentation**: Document expected inputs, outputs, and behavior
7. **Security**: Sanitize inputs, avoid code execution vulnerabilities
8. **State management**: Avoid maintaining state between function calls when possible
