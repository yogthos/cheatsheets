general tools
* lightweight container https://github.com/lynaghk/vibe/
* beads https://github.com/steveyegge/beads
* browser cli https://github.com/cosinusalpha/webctl
* coding agent toolkit providing semantic retrieval and editing capabilities  https://github.com/oraios/serena
* Annotate and review coding agent plans visually https://github.com/backnotprop/plannotator
* memory for projects https://github.com/milla-jovovich/mempalace

REPL based

* [devstral](https://mistral.ai/news/devstral-2-vibe-cli) https://github.com/mistralai/mistral-vibe
* [nekot](https://github.com/BalanceBalls/nekot)
* setting with Deepseek https://api-docs.deepseek.com/guides/anthropic_api
* setting up with GLM https://docs.z.ai/scenario-example/develop-tools/claude
* ATLAS https://github.com/itigges22/ATLAS
    
IDE based
* [continue](https://github.com/continuedev/continue)
* [roo-code](https://github.com/RooCodeInc/Roo-Code?tab=readme-ov-file)

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
* llamafile https://mozilla-ai.github.io/llamafile/creating_llamafiles/

### analytics tools

* https://github.com/badboysm890/ClaraVerse
* https://github.com/quelmap-inc/quelmap
