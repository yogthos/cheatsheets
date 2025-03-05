### Understanding Ollama Commands

Ollama uses simple commands to manage models. Here are some key commands you'll need:

* `ollama -v` Checks the installed version of Ollama.
* `ollama pull <model_name>:<tag>` Downloads a model from the Ollama library.
* `ollama run <model_name>:<tag>` Runs a model and starts an interactive chat session.
* `ollama create <model_name> -f <Modelfile>` Creates a custom model using a Modelfile.
* `ollama show <model_name>` Shows information about a model.
* `ollama ps` Lists the models that are currently running.
* `ollama stop <model_name>` Unloads a model from memory.
* `ollama cp <source_model> <destination_model>` Copies a model.
* `ollama rm <model_name>` Deletes a model.
* `ollama push <model_name>:<tag>` Uploads a model to a model library.

### Qwen Models on Ollama

https://ollama.com/library/qwq:32b

    ollama run qwq:32b

### DeepSeek Models on Ollama

DeepSeek models are available on the Ollama library in different sizes and formats. Here's a breakdown:

* Model Sizes: The models come in various sizes, such as 1.5b, 7b, 8b, 14b, 32b, 70b, and 671b. The 'b' stands for billion parameters. Larger models usually perform better but need more resources.
* Quantized Versions: Some models are available in quantized versions (e.g., q4_K_M, q8_0). These versions use less memory and can run faster, but may have a slight drop in quality.
* Distilled Versions: DeepSeek also offers distilled versions (e.g., qwen-distill, llama-distill). These are smaller models that have been trained to act like the larger ones, balancing performance and resource use.
* Tags: Each model has a latest tag and specific tags that show the size, quantization, and distillation method.

some of the available tags


* latest
* 1.5b
* 7b
* 8b
* 14b
* 32b
* 70b
* 671b
* 1.5b-qwen-distill-fp16
* 1.5b-qwen-distill-q4_K_M
* 1.5b-qwen-distill-q8_0
* 14b-qwen-distill-fp16
* 14b-qwen-distill-q4_K_M
* 14b-qwen-distill-q8_0
* 32b-qwen-distill-fp16
* 32b-qwen-distill-q4_K_M
* 32b-qwen-distill-q8_0
* 70b-llama-distill-fp16
* 70b-llama-distill-q4_K_M
* 70b-llama-distill-q8_0
* 7b-qwen-distill-fp16
* 7b-qwen-distill-q4_K_M
* 7b-qwen-distill-q8_0
* 8b-llama-distill-fp16
* 8b-llama-distill-q4_K_M
* 8b-llama-distill-q8_0

### Running a Model

After downloading a model, you can run it using the command:

    ollama run deepseek-r1:<model_tag>

For example, to run the latest 7B model:

    ollama run deepseek-r1:7b

To run the 14B Qwen-distilled model with q4_K_M quantization:

    ollama run deepseek-r1:14b-qwen-distill-q4_K_M

To run the 70B Llama-distilled model with fp16 precision:

    ollama run deepseek-r1:70b-llama-distill-fp16

This will start an interactive chat session where you can ask the model questions.

### Using the API

You can also use the Ollama API with DeepSeek models. Here's an example using curl:

```
curl http://localhost:11434/api/generate -d '{
  "model": "deepseek-r1:7b",
  "prompt": "Write a short poem about the stars."
}'
```

For chat completions:

```
curl http://localhost:11434/api/chat -d '{
  "model": "deepseek-r1:7b",
  "messages": [
    {
      "role": "user",
      "content": "Write a short poem about the stars."
    }
  ]
}'
```

### Using the OpenAI-Compatible API

Ollama provides an experimental compatibility layer with parts of the OpenAI API. This allows you to use existing applications and tools designed for OpenAI with your local Ollama server.
Key Concepts

* API Endpoint: Ollama's OpenAI-compatible API is served at `http://localhost:11434/v1.`
* Authentication: Ollama's API doesn't require an API key for local use. You can often use a placeholder like "ollama" for the api_key parameter in your client.
* Partial Compatibility: Ollama's compatibility is experimental and partial. Not all features of the OpenAI API are supported, and there may be some differences in behavior.
* Focus on Core Functionality: Ollama primarily aims to support the core functionality of the OpenAI API, such as chat completions, text completions, model listing, and embeddings.

### example OpenAI client

```javascript
import OpenAI from 'openai';

const openai = new OpenAI({
  baseURL: 'http://localhost:11434/v1/',
  apiKey: 'ollama', // Required but ignored
});

// Example chat completion
const chatCompletion = await openai.chat.completions.create({
  messages: [{ role: 'user', content: 'Say this is a test' }],
  model: 'deepseek-r1:7b',
});

// Example text completion
const completion = await openai.completions.create({
  model: "deepseek-r1:7b",
  prompt: "Say this is a test.",
});

// Example list models
const listCompletion = await openai.models.list()

// Example get model info
const model = await openai.models.retrieve("deepseek-r1:7b")
```
