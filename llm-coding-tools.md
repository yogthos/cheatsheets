general tools
* beads https://github.com/steveyegge/beads
* browser cli https://github.com/cosinusalpha/webctl
* coding agent toolkit providing semantic retrieval and editing capabilities  https://github.com/oraios/serena
* Annotate and review coding agent plans visually https://github.com/backnotprop/plannotator

REPL based
* [pi-coding-agent](https://github.com/badlogic/pi-mono/tree/main) https://shittycodingagent.ai/
* [devstral](https://mistral.ai/news/devstral-2-vibe-cli) https://github.com/mistralai/mistral-vibe
* [nekot](https://github.com/BalanceBalls/nekot)
* [aider](https://github.com/Aider-AI/aider)
* [plandex](https://github.com/plandex-ai/plandex)
* [qwen-code](https://github.com/QwenLM/qwen-code)
* [claude-code](https://www.anthropic.com/claude-code)
  * setting with Deepseek https://api-docs.deepseek.com/guides/anthropic_api
  * setting up with GLM https://docs.z.ai/scenario-example/develop-tools/claude
* [crush](https://github.com/charmbracelet/crush)
  * currently using with GLM (easy to reconfigure) 
* opencode `npm install -g opencode-ai` - works with GLM
  
IDE based
* [continue](https://github.com/continuedev/continue)
* [roo-code](https://github.com/RooCodeInc/Roo-Code?tab=readme-ov-file)

to set up claude-code mcp config for Clojure, add the following to `~/.claude.json`

```
"mcpServers": {
        "clojure-mcp": {
          "command": "/bin/sh",
          "args": [
            "-c",
            "export PATH=/opt/homebrew/bin:$PATH; exec clojure -X:mcp :port 7888"
          ]
        },
        "code-mode": {
           "command": "npx",
            "args": [
               "@utcp/mcp-bridge"
            ],
            "env": {
               "UTCP_CONFIG_FILE": "~/.config/utcp/.utcp_config.json"
            }
         }
      }
```

another way `claude mcp add mcp-mermaid --scope user /opt/homebrew/bin/mcp-mermaid`

docs https://docs.anthropic.com/en/docs/claude-code/mcp

### useful MCPs

* https://github.com/hustcc/mcp-mermaid
* https://github.com/universal-tool-calling-protocol/code-mode

sample config:

```javascript
{
  "load_variables_from": [
    {
      "variable_loader_type": "dotenv",
      "env_file_path": "~/.env"
    }
  ],
  "manual_call_templates": [
    {
      "name": "puppeteer",
      "call_template_type": "mcp",
      "config": {
        "mcpServers": {
          "puppeteer_server": {
            "command": "npx",
            "args": ["-y", "@modelcontextprotocol/server-puppeteer"],
            "env": {
              "PUPPETEER_LAUNCH_OPTIONS": "{\"headless\": false}"
            }
          }
        }
      }
    }
  ]
}
```

### running models

* https://github.com/ggml-org/llama.cpp
* https://github.com/menloresearch/jan
* llamafile https://mozilla-ai.github.io/llamafile/creating_llamafiles/

### analytics tools

* https://github.com/badboysm890/ClaraVerse
* https://github.com/quelmap-inc/quelmap
