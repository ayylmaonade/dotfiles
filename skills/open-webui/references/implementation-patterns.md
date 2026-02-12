# Implementation Patterns & API Reference

**Reference**: Combined from Open-WebUI plugin documentation and best practices

## Overview

This document contains practical code patterns, API references, and implementation guidelines for developing Open-WebUI tools and functions.

## Code Structure Patterns

### Basic Filter Function

```python
from fastapi import HTTPException
from typing import Optional
from pydantic import BaseModel

class FilterValves(BaseModel):
    enabled: bool = True
    priority: int = 0

class MyFilterFunction:
    def __init__(self, valves: Optional[FilterValves] = None):
        self.valves = valves or FilterValves()

    async def inlet(self, message: str) -> str:
        """
        Pre-processing phase: Modify input before LLM sees it.
        """
        if not self.valves.enabled:
            return message

        # Add system context
        return f"SYSTEM CONTEXT: Always respond with code snippets. Message: {message}"

    async def stream(self, chunk: str) -> str:
        """
        Real-time streaming phase: Modify output as it generates.
        """
        if not self.valves.enabled:
            return chunk

        # Format markdown as we stream
        formatted = f"```python\n{chunk}\n```"
        return formatted

    async def outlet(self, message: str) -> str:
        """
        Post-processing phase: Modify final output.
        """
        if not self.valves.enabled:
            return message

        # Clean up and format
        return message.strip()
```

### Basic Pipe Function

```python
from pydantic import BaseModel

class PipeValves(BaseModel):
    temperature: float = 0.7
    max_tokens: int = 2048

class MyPipeFunction:
    def __init__(self, valves: Optional[PipeValves] = None):
        self.valves = valves or PipeValves()

    async def __call__(self, prompt: str):
        """
        Execute and return text response.
        This appears as a standalone model.
        """
        # Pipe functions act as standalone models
        # They execute independently and return text
        response = generate_completion(prompt, **self.valves.dict())
        return response
```

### Basic Action Function

```python
from pydantic import BaseModel

class ActionValves(BaseModel):
    enabled: bool = True

class MyActionFunction:
    def __init__(self, valves: Optional[ActionValves] = None):
        self.valves = valves or ActionValves()

    async def __call__(self, prompt: str):
        """
        User-triggered action function.
        Adds custom buttons to chat interface.
        """
        if not self.valves.enabled:
            raise ValueError("Action function not enabled")

        # Return action to trigger other functions
        return {
            "action": "generate_code",
            "prompt": "Generate Python code",
            "data": {"additional": "parameters"}
        }
```

## Universal Tool Pattern

### Complete Universal Tool Implementation

```python
from datetime import datetime
from fastapi.responses import HTMLResponse
from typing import Optional

class UniversalTool:
    """Universal tool that works in both Default and Native modes."""

    async def execute(self, prompt: str, __event_emitter__=None, metadata=None):
        """
        Universal tool implementation with mode detection.
        """
        # Detect mode
        is_native_mode = metadata and metadata.get("params", {}).get("function_calling") == "native"

        # Event emitter handling
        if __event_emitter__:
            if is_native_mode:
                # Native mode: Limited event support
                await __event_emitter__({
                    "type": "status",
                    "data": {
                        "description": "Processing in native mode...",
                        "done": False
                    }
                })
            else:
                # Default mode: Full event support
                await __event_emitter__({
                    "type": "message",
                    "data": {
                        "content": "Processing with full event support...",
                        "type": "text"
                    }
                })

        # Tool processing
        await self._process_data(prompt, __event_emitter__, is_native_mode)

        # Final status
        if __event_emitter__:
            await __event_emitter__({
                "type": "status",
                "data": {
                    "description": "Completed successfully",
                    "done": True
                }
            })

        return "Tool execution completed"

    async def _process_data(self, prompt: str, __event_emitter__=None, is_native_mode=False):
        """Internal processing logic."""
        # Your tool implementation here
        if __event_emitter__:
            await __event_emitter__({
                "type": "citation",
                "data": {
                    "document": "Processed result content",
                    "metadata": [{
                        "date_accessed": datetime.now().isoformat(),
                        "source": "Internal Tool",
                        "url": "internal://tool-result"
                    }],
                    "source": {
                        "name": "Internal Tool",
                        "url": "internal://tool-result"
                    }
                }
            })
```

### Universal Tool with Multiple Event Types

```python
class AdvancedUniversalTool:
    async def execute(self, prompt: str, __event_emitter__=None, metadata=None):
        is_native_mode = metadata and metadata.get("params", {}).get("function_calling") == "native"

        if __event_emitter__:
            # Status update (always compatible)
            await __event_emitter__({
                "type": "status",
                "data": {"description": "Starting...", "done": False}
            })

            # Notification (always compatible)
            await __event_emitter__({
                "type": "notification",
                "data": {"message": "Processing started"}
            })

            # Follow-up suggestions (always compatible)
            await __event_emitter__({
                "type": "chat:message:follow_ups",
                "data": ["Analyze further", "Export data", "Generate report"]
            })

        # Processing...

        if __event_emitter__:
            await __event_emitter__({
                "type": "status",
                "data": {"description": "Complete", "done": True}
            })

            await __event_emitter__({
                "type": "chat:title",
                "data": {"title": "Analysis Results"}
            })

            await __event_emitter__({
                "type": "chat:tags",
                "data": {"tags": ["analysis", "completed"]}
            })

        return "Analysis complete"
```

## HTML Embedding Patterns

### Simple Chart Embedding

```python
from fastapi.responses import HTMLResponse

async def chart_tool(self, data: str, __event_emitter__=None):
    """
    Tool that generates an interactive chart.
    """
    chart_html = f"""
    <!DOCTYPE html>
    <html>
    <head>
        <title>Interactive Chart</title>
        <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>
    </head>
    <body>
        <div id="chart" style="width:100%;height:500px;"></div>
        <script>
            const data = {data};
            Plotly.newPlot('chart', data, {
                title: 'Interactive Chart',
                responsive: true
            });
        </script>
    </body>
    </html>
    """

    return HTMLResponse(
        content=chart_html,
        headers={"Content-Disposition": "inline"}
    )
```

### Interactive Dashboard

```python
from fastapi.responses import HTMLResponse

async def dashboard_tool(self, metrics: dict, __event_emitter__=None):
    """
    Tool that generates an interactive dashboard.
    """
    dashboard_html = f"""
    <!DOCTYPE html>
    <html>
    <head>
        <title>Analytics Dashboard</title>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <style>
            .dashboard-container {{
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 20px;
                padding: 20px;
            }}
            .chart-card {{
                background: #f5f5f5;
                padding: 20px;
                border-radius: 8px;
            }}
            h2 {{ text-align: center; }}
        </style>
    </head>
    <body>
        <h2>Analytics Dashboard</h2>
        <div class="dashboard-container">
            <div class="chart-card">
                <canvas id="chart1"></canvas>
            </div>
            <div class="chart-card">
                <canvas id="chart2"></canvas>
            </div>
        </div>
        <script>
            // Chart configurations
            const options = {{
                responsive: true,
                maintainAspectRatio: false
            }};

            // Chart 1
            new Chart(document.getElementById('chart1'), {{
                type: 'bar',
                data: {metrics['bar']},
                options: options
            }});

            // Chart 2
            new Chart(document.getElementById('chart2'), {{
                type: 'line',
                data: {metrics['line']},
                options: options
            }});
        </script>
    </body>
    </html>
    """

    return HTMLResponse(
        content=dashboard_html,
        headers={"Content-Disposition": "inline"}
    )
```

### Code Execution Environment

```python
from fastapi.responses import HTMLResponse

async def code_runner(self, code: str, __event_emitter__=None):
    """
    Tool that provides a code execution environment.
    """
    runner_html = f"""
    <!DOCTYPE html>
    <html>
    <head>
        <title>Code Runner</title>
        <style>
            body {{
                font-family: monospace;
                margin: 0;
                padding: 0;
            }}
            #editor {{
                width: 100%;
                height: 400px;
                padding: 10px;
                background: #f8f9fa;
                border: 1px solid #ddd;
            }}
            #output {{
                width: 100%;
                padding: 10px;
                background: #1e1e1e;
                color: #d4d4d4;
                min-height: 200px;
            }}
            .btn {{
                padding: 10px 20px;
                background: #28a745;
                color: white;
                border: none;
                cursor: pointer;
            }}
        </style>
    </head>
    <body>
        <textarea id="editor">{{code}}</textarea>
        <br>
        <button class="btn" onclick="runCode()">Run Code</button>
        <pre id="output"></pre>

        <script>
            function runCode() {{
                const code = document.getElementById('editor').value;
                const output = document.getElementById('output');

                // Security: Use a sandboxed environment
                const safeExecution = new Function(code);

                try {{
                    output.textContent = "Output:\\n";
                    output.textContent += safeExecution();
                }} catch (error) {{
                    output.textContent = "Error:\\n" + error.message;
                }}
            }}

            runCode();
        </script>
    </body>
    </html>
    """

    return HTMLResponse(
        content=runner_html,
        headers={"Content-Disposition": "inline"}
    )
```

## Error Handling Patterns

### Structured Error Handling

```python
from fastapi import HTTPException

async def robust_tool(self, prompt: str, __event_emitter__=None, metadata=None):
    """
    Tool with comprehensive error handling.
    """
    is_native_mode = metadata and metadata.get("params", {}).get("function_calling") == "native"

    try:
        if __event_emitter__:
            await __event_emitter__({
                "type": "status",
                "data": {
                    "description": "Starting execution...",
                    "done": False
                }
            })

        # Validate input
        if not prompt or len(prompt) < 10:
            raise ValueError("Input prompt is too short")

        # Processing
        result = await self._process(prompt)

        if __event_emitter__:
            await __event_emitter__({
                "type": "status",
                "data": {
                    "description": "Execution complete",
                    "done": True
                }
            })

            await __event_emitter__({
                "type": "notification",
                "data": {
                    "message": "Task completed successfully"
                }
            })

        return f"Result: {result}"

    except ValueError as e:
        if __event_emitter__:
            await __event_emitter__({
                "type": "status",
                "data": {
                    "description": "Validation error",
                    "done": True
                }
            })

            await __event_emitter__({
                "type": "chat:message:error",
                "data": {
                    "message": f"Error: {str(e)}"
                }
            })

        raise HTTPException(status_code=400, detail=str(e))

    except Exception as e:
        if __event_emitter__:
            await __event_emitter__({
                "type": "status",
                "data": {
                    "description": "Unexpected error",
                    "done": True
                }
            })

            await __event_emitter__({
                "type": "chat:message:error",
                "data": {
                    "message": f"An unexpected error occurred: {str(e)}"
                }
            })

        raise HTTPException(status_code=500, detail="Internal server error")
```

## Tool Schema Definition

### Complete Tool Schema

```python
from typing import Dict, Any, List
from pydantic import BaseModel

class ToolValves(BaseModel):
    """Tool configuration parameters."""
    enabled: bool = True
    timeout: int = 30  # seconds
    max_retries: int = 3

class ToolResponse(BaseModel):
    """Tool response schema."""
    success: bool
    data: Any = None
    error: str = None
    metadata: Dict[str, Any] = {}

class UniversalTool:
    def __init__(self, valves: Optional[ToolValves] = None):
        self.valves = valves or ToolValves()

    async def execute(self, prompt: str, __event_emitter__=None, metadata=None) -> ToolResponse:
        """
        Universal tool implementation.
        Returns structured response with metadata.
        """
        start_time = datetime.now()
        response = ToolResponse(success=False)

        try:
            # Mode detection
            is_native_mode = metadata and metadata.get("params", {}).get("function_calling") == "native"

            # Event handling
            if __event_emitter__:
                if is_native_mode:
                    await __event_emitter__({
                        "type": "status",
                        "data": {"description": "Native mode processing", "done": False}
                    })
                else:
                    await __event_emitter__({
                        "type": "message",
                        "data": {"content": "Default mode processing", "type": "text"}
                    })

            # Process data
            result = await self._process(prompt, __event_emitter__, is_native_mode)

            response.success = True
            response.data = result

            if __event_emitter__:
                await __event_emitter__({
                    "type": "status",
                    "data": {"description": "Processing complete", "done": True}
                })

        except Exception as e:
            response.error = str(e)
            response.metadata["error_type"] = type(e).__name__

            if __event_emitter__:
                await __event_emitter__({
                    "type": "status",
                    "data": {"description": "Error occurred", "done": True}
                })

                await __event_emitter__({
                    "type": "chat:message:error",
                    "data": {"message": str(e)}
                })

        response.metadata["execution_time"] = (datetime.now() - start_time).total_seconds()

        return response
```

## API Patterns

### Model Integration Patterns

```python
from openai import OpenAI

class ModelPipeFunction:
    """Pipe function that wraps another LLM model."""

    async def __call__(self, prompt: str):
        client = OpenAI(api_key=self.valves.api_key)

        response = client.chat.completions.create(
            model=self.valves.model,
            messages=[
                {"role": "system", "content": self.valves.system_prompt},
                {"role": "user", "content": prompt}
            ],
            temperature=self.valves.temperature,
            max_tokens=self.valves.max_tokens
        )

        return response.choices[0].message.content
```

### Data Source Integration

```python
import httpx

class APITool:
    """Tool that integrates with external APIs."""

    async def execute(self, prompt: str, __event_emitter__=None, metadata=None):
        is_native_mode = metadata and metadata.get("params", {}).get("function_calling") == "native"

        if __event_emitter__:
            await __event_emitter__({
                "type": "status",
                "data": {"description": "Querying API...", "done": False}
            })

        try:
            async with httpx.AsyncClient() as client:
                response = await client.get(
                    self.valves.api_url,
                    params={"query": prompt},
                    headers={"Authorization": f"Bearer {self.valves.api_key}"},
                    timeout=self.valves.timeout
                )
                response.raise_for_status()

                data = response.json()

                if __event_emitter__:
                    await __event_emitter__({
                        "type": "citation",
                        "data": {
                            "document": f"API response: {data}",
                            "metadata": [{
                                "date_accessed": datetime.now().isoformat(),
                                "source": "External API",
                                "url": self.valves.api_url
                            }],
                            "source": {
                                "name": "External API",
                                "url": self.valves.api_url
                            }
                        }
                    })

                    await __event_emitter__({
                        "type": "status",
                        "data": {"description": "API complete", "done": True}
                    })

                return data

        except httpx.HTTPError as e:
            if __event_emitter__:
                await __event_emitter__({
                    "type": "status",
                    "data": {"description": "API error", "done": True}
                })

                await __event_emitter__({
                    "type": "chat:message:error",
                    "data": {"message": f"API request failed: {str(e)}"}
                })

            raise
```

## Configuration Patterns

### Dynamic Configuration

```python
from pydantic import BaseModel, Field

class DynamicToolConfig(BaseModel):
    """Tool configuration that can be updated at runtime."""

    enabled: bool = Field(default=True, description="Enable/disable tool")
    temperature: float = Field(default=0.7, ge=0, le=1)
    max_tokens: int = Field(default=2048, ge=1)
    timeout: int = Field(default=30, ge=1)

    class Config:
        schema_extra = {
            "example": {
                "enabled": True,
                "temperature": 0.7,
                "max_tokens": 2048,
                "timeout": 30
            }
        }
```

## Testing Patterns

### Unit Testing Pattern

```python
import pytest
from unittest.mock import AsyncMock, MagicMock

class TestUniversalTool:
    @pytest.mark.asyncio
    async def test_tool_execution(self):
        tool = UniversalTool()
        mock_event_emitter = AsyncMock()

        result = await tool.execute(
            "test prompt",
            __event_emitter__=mock_event_emitter
        )

        assert result == "Tool execution completed"
        mock_event_emitter.assert_called()

    @pytest.mark.asyncio
    async def test_mode_detection(self):
        tool = UniversalTool()
        metadata = {
            "params": {
                "function_calling": "native"
            }
        }

        result = await tool.execute(
            "test",
            metadata=metadata
        )

        # Test native mode behavior
        assert result == "Tool execution completed"
```

## Performance Optimization

### Async Processing Pattern

```python
class AsyncTool:
    """Tool with optimized async processing."""

    async def execute(self, prompt: str, __event_emitter__=None, metadata=None):
        is_native_mode = metadata and metadata.get("params", {}).get("function_calling") == "native"

        # Use async processing for independent tasks
        tasks = [
            self._validate_input(prompt),
            self._fetch_data(prompt)
        ]

        validated, data = await asyncio.gather(*tasks)

        if not validated:
            raise ValueError("Validation failed")

        if __event_emitter__:
            await __event_emitter__({
                "type": "status",
                "data": {"description": "Processing complete", "done": True}
            })

        return data
```

## Security Patterns

### Input Sanitization

```python
import re
from html import escape

class SecureTool:
    """Tool with security measures."""

    async def execute(self, prompt: str, __event_emitter__=None, metadata=None):
        # Sanitize input
        sanitized = self._sanitize_input(prompt)

        # Validate
        if not self._is_valid_input(sanitized):
            raise ValueError("Invalid input")

        # Process with sanitized input
        result = await self._process(sanitized)

        # Sanitize output
        safe_result = self._sanitize_output(result)

        return safe_result

    def _sanitize_input(self, input: str) -> str:
        """Remove potentially dangerous characters."""
        # Remove script tags
        input = re.sub(r'<script\b[^>]*>(.*?)</script>', '', input, flags=re.IGNORECASE)

        # Escape HTML
        input = escape(input)

        return input

    def _is_valid_input(self, input: str) -> bool:
        """Validate input length and content."""
        return len(input) > 10 and len(input) < 10000

    def _sanitize_output(self, output: str) -> str:
        """Sanitize output before returning."""
        # Remove dangerous patterns
        output = re.sub(r'javascript:', '', output)
        output = re.sub(r'on\w+\s*=', '', output)

        return output
```

## Summary

These patterns provide a foundation for building robust, mode-safe Open-WebUI tools. Remember to:
- Always implement mode detection
- Use only compatible event types
- Provide comprehensive error handling
- Validate all inputs and sanitize outputs
- Consider security implications
- Test thoroughly in both modes
