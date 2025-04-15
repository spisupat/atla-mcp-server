# Atla MCP Server
An MCP server implementation that provides a standardized interface for LLMs to interact with the Atla SDK and use our [state-of-the-art evaluation models](https://www.atla-ai.com/post/selene-1).
This version uses `sse` transport instead of `stdio` - this lets MCP servers talk to `localhost:8001` using the `mcp-remote` package as follows:
```shell
npx mcp-remote http://localhost:8001/sse --header "Authorization: Bearer $ATLA_API_KEY"
```
**Steps**
- You'll need to install this repository (including the Node [dependencies](https://www.npmjs.com/package/mcp-remote) `pip install -e . && npm install`)
- You'll need to "run" `atla-mcp-server.py` to host the server locally `python run src/atla-mcp-server.py` (this is specified inside the .py using uvicorn) 
- You can then use `localhost:8001/sse` as the URL for your server.

```
- If you are building with OpenAI agents, you will also need an `OPENAI_API_KEY` in your environment
```

## Usage
### Use with OpenAI Agents SDK
The atla-mcp-server can be used with the [OpenAI agents SDK](https://openai.github.io/openai-agents-python/) as follows:
```python
from agents import Agent
from agents.mcp import MCPServerStdio
import os
atla_api_key = os.environ.get("ATLA_API_KEY", "<your_atla_api_key>") # You can also manually set your ATLA_API_KEY here

async with MCPServerStdio(
        params={
            "command": "npx",
			"args": [
				"mcp-remote",
				"http://localhost:8001/sse",
				"--header",
				"Authorization: Bearer ${ATLA_API_KEY}"
			],
            "env": {"ATLA_API_KEY":atla_api_key}
        }
    ) as atla_mcp_server:
        # Create an agent with the Atla evaluation server
        agent = Agent(
            name="AssistantWithAtlaEval",
            instructions="""
            You are a helpful assistant. Your goal is to provide high-quality responses to user requests.
            You can use the Atla evaluation tool to improve your responses.
            """,
            mcp_servers=[atla_mcp_server], # You can equip any Agent with Atla's MCP server like this
            model="gpt-4o-mini"
        )
```

For an example, run the following from `/path/to/atla-mcp-server`:
```shell
uv run examples/agent_with_atla_eval.py "Write a one-line poem about the ocean. Evaluate it with atla for cliche and improve it once using the feedback."
```
You can also try out the notebook version of this example in `examples/agent_notebook.ipynb`.

### Use with Claude Desktop
- Download Claude Desktop from [here](https://claude.ai/download) (this is a local server, and won’t work with claude.ai on web) 
- Click on Claude → Settings… → Developer → Edit Config
- Add the following to the `claude_desktop_config.json` file (ensure that you replace `<your-atla-api-key>` with your actual Atla API key):
```json
{
	"mcpServers": {
		"atla-mcp-server": {
			"command": "npx",
			"args": [
				"mcp-remote",
				"http://localhost:8001/sse",
				"--header",
				"Authorization: Bearer ${ATLA_API_KEY}"
			],
			"env": {
			"ATLA_API_KEY": "<your-atla-api-key>"
			}
		}
	}
}
```
- When you restart Claude Desktop, you should see `atla-mcp-server` in the list of available MCP servers, and 5 tools available to Claude.
- Example prompt to Claude: `Write a poem, evaluate it with atla for helpfulness`


### Use with Cursor
- Add the following to your `.cursor/mcp.json`:
```json
{
	"mcpServers": {
		"atla-mcp-server": {
			"command": "npx",
			"args": [
				"mcp-remote",
				"http://localhost:8001/sse",
				"--header",
				"Authorization: Bearer ${ATLA_API_KEY}"
			],
			"env": {
			"ATLA_API_KEY": "<your-atla-api-key>"
			}
		}
	}
}
```
