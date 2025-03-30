# Academia
Learning App using LLM Ollama with SwiftUI, MVVM and SwiftOpenAI

## Use case

The app generates multiple-choice quizzes based on the text and documents information provided, leveraging OLLAMA generative AI

## Screenshots

<img src="https://github.com/dave-testaverde/Academia/blob/main/screen/01.png" alt="Home Screen" width="200"> <img src="https://github.com/dave-testaverde/Academia/blob/main/screen/02.png" alt="Generative Screen" width="200"> <img src="https://github.com/dave-testaverde/Academia/blob/main/screen/03.png" alt="RAG Screen" width="200"> <img src="https://github.com/dave-testaverde/Academia/blob/main/screen/04.png" alt="RAG Docs Screen" width="200"> 

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
