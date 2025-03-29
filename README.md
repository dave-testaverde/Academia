# Academia
Learning App using LLM Ollama with SwiftUI, MVVM and SwiftOpenAI

## Use case

The app generates multiple-choice quizzes based on the text and documents information provided, leveraging OLLAMA generative AI
## Screenshots

![App Screenshot](https://via.placeholder.com/468x300?text=App+Screenshot+Here)


## Requirements

 - Install Ollama
 - Install SwiftOpenAI (last commit)


## Configure Ollama

Install all models

```bash
  ollama pull llama3
  ollama pull mxbai-embed-large
```

Test generative model

```bash
  curl -X POST http://localhost:11434/api/generate -d '{
    "model": "llama3",
    "prompt":"Why is the sky blue?"
  }'
```

Test embeddings model

```bash
  curl http://localhost:11434/api/embed -d '{
    "model": "mxbai-embed-large",
    "input": "Llamas are members of the camelid family"
  }'
```
    
