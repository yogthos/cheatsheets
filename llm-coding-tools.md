REPL based
* [aider](https://github.com/Aider-AI/aider)
* [plandex](https://github.com/plandex-ai/plandex)
* [qwen-code](https://github.com/QwenLM/qwen-code)
* [claude-code](https://www.anthropic.com/claude-code)
  * setting with Deepseek https://api-docs.deepseek.com/guides/anthropic_api
  * setting up with GLM https://docs.z.ai/scenario-example/develop-tools/claude
* [crush](https://github.com/charmbracelet/crush)
  * currently using with Gemini 
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
        }
      }
```

another way `claude mcp add mcp-mermaid --scope user /opt/homebrew/bin/mcp-mermaid`

docs https://docs.anthropic.com/en/docs/claude-code/mcp

### useful MCPs

* https://github.com/hustcc/mcp-mermaid

### running models

* https://github.com/ggml-org/llama.cpp
* https://github.com/menloresearch/jan

### analytics tools

* https://github.com/badboysm890/ClaraVerse
* https://github.com/quelmap-inc/quelmap
