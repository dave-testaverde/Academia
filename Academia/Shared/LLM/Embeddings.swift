//
//  Embeddings.swift
//  Academia
//
//  Created by Dave on 17/02/25.
//

import Foundation
import Combine
import SwiftOpenAI

extension Ollama {
    
    func sequencies() throws -> [String] {
        guard !viewModel!.contextRAG.isEmpty else {
            throw RuntimeError("TextField is empty")
        }
        let docs = PDF2text()
        guard !docs.isEmpty else {
            throw RuntimeError("No documents loaded")
        }
        var res: [String] = viewModel!.contextRAG.appending(docs).components(separatedBy: ".").dropLast()
        return res
    }
    
    func requestEmbd(prompt: String) -> URLRequest {
        var request = URLRequest(url: URL(string:  Ollama.OLLAMA_BASE_URL + Ollama.EMBEDDINGS)!)
        request.httpMethod = "POST"
        let data = try! JSONEncoder().encode(
            EmbeddingRequest(model: Ollama.EMBEDDINGS_MODEL, input: prompt)
        )
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func createEmbeddings(prompt: String, doc: Int = 1) {
        urlSession.dataTaskPublisher(for: requestEmbd(prompt: prompt))
            .first()
            .receive(on: DispatchQueue.main)
            .tryMap({ return $0.data })
            .decode(type: EmbeddingResponse.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        ()
                    case .failure(let error):
                        print("Failed to Send POST Request \(error)")
                }
            }, receiveValue: { [self] embd in
                registerEmbeddings(embd: embd, doc: doc, prompt: prompt)
            })
            .store(in: &cancellables)
    }
    
    func genAllEmbds() {
        viewModel!.onLoading()
        embeddingsNodes = []
        let docs: [String]
        do {
            docs = try sequencies()
        } catch {
            return print(error.localizedDescription)
        }
        for (i, s) in docs.enumerated() {
            let index = i + 1
            createEmbeddings(prompt: s, doc: index)
        }
    }
    
    func registerEmbeddings(embd: EmbeddingResponse, doc: Int, prompt: String){
        embeddingsNodes.append(EmbeddingNode(id: String(doc), embeddings: embd.embeddings, documents: prompt))
        let docs = try! sequencies()
        if(embeddingsNodes.count == docs.count) {
            Task {
                await onLoadedEmbds()
            }
        }
    }
    
    func onLoadedEmbds() async {
        let data = try! JSONEncoder().encode(embeddingsNodes)
        
        let input = Assistant.generateQuiz(of: viewModel!.prompt.context, with: Int(viewModel!.prompt.difficulty))
        let prompt: String = "Using this data: \(String(data: data, encoding: .utf8)!). Respond only with a JSON object by running this prompt: [\(input)]"
        
        createPrompt(prompt: prompt)
    }
    
    func createPrompt(prompt: String) {
        Task {
            let session = urlSession
            let (data, _) = try await session.bytes(
                for: requestGeneration(prompt: prompt),
                delegate: session.delegate as? URLSessionTaskDelegate
            )
            for try await line in data.lines {
                do {
                    let gen: GenerationResponse = try JSONDecoder().decode(GenerationResponse.self, from: line.data(using: .utf8)!)
                    viewModel!.rcvMessage(from: gen.response)
                } catch {
                    print("not decodable")
                }
            }
            viewModel!.onLoaded()
        }
    }
    
    func requestGeneration(prompt: String) -> URLRequest {
        var request = URLRequest(url: URL(string:  Ollama.OLLAMA_BASE_URL + Ollama.LLM)!)
        request.httpMethod = "POST"
        let data = try! JSONEncoder().encode(
            GenerationRequest(model: Ollama.LLM3_MODEL, prompt: prompt)
        )
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = Ollama.REQUEST_MAX_TIMEOUT
        return request
    }
    
}
