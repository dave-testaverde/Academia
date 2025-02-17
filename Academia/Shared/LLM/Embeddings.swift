//
//  Embeddings.swift
//  Academia
//
//  Created by Dave on 17/02/25.
//

import Foundation
import SwiftOpenAI
import Combine

class Embeddings {
    let urlSession: URLSession = .shared
    var cancellables = Set<AnyCancellable>()
    
    var embeddingsNodes: [EmbeddingNode] = []
    
    let sequencies: [String] = [
      /*"Llamas are members of the camelid family meaning they're pretty closely related to vicuñas and camels",
      "Llamas were first domesticated and used as pack animals 4,000 to 5,000 years ago in the Peruvian highlands",
      "Llamas can grow as much as 6 feet tall though the average llama between 5 feet 6 inches and 5 feet 9 inches tall",
      "Llamas weigh between 280 and 450 pounds and can carry 25 to 30 percent of their body weight",
      "Llamas are vegetarians and have very efficient digestive systems",*/
      "Llamas live to be about 99 years old, though some only live for 11 years and others live to be 22 years old"
    ]
    
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
        embeddingsNodes = []
        for (i, s) in sequencies.enumerated() {
            let index = i + 1
            createEmbeddings(prompt: s, doc: index)
        }
    }
    
    func registerEmbeddings(embd: EmbeddingResponse, doc: Int, prompt: String){
        embeddingsNodes.append(EmbeddingNode(id: String(doc), embeddings: embd.embeddings, documents: prompt))
        if(embeddingsNodes.count == sequencies.count) {
            Task{
                await onLoadedEmbds()
            }
        }
    }
    
    func onLoadedEmbds() async {
        let data = try! JSONEncoder().encode(embeddingsNodes)
        
        let input = "How long do llamas live?"
        let prompt: String = "Using this data: \(String(data: data, encoding: .utf8)!). Respond to this prompt: [\(input)]"
        
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
                do{
                    let gen: GenerationResponse = try JSONDecoder().decode(GenerationResponse.self, from: line.data(using: .utf8)!)
                    print(gen.response)
                } catch {
                    print("not decodable")
                }
            }
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
