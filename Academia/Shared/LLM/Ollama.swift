//
//  Ollama.swift
//  Academia
//
//  Created by Dave on 29/01/25.
//

import Foundation
import SwiftOpenAI
import Combine

@Observable
class Ollama {
    private static let OLLAMA_BASE_URL: String = "http://localhost:11434"
    private static let EMBEDDINGS: String = "/api/embed"
    
    private var streamTask: Task<Void, Never>? = nil
    
    let urlSession: URLSession = .shared
    
    let service: OpenAIService
    var viewModel: AcademiaViewModel?
    
    var embeddingsNodes: [EmbeddingNode] = []
    
    var cancellables = Set<AnyCancellable>()
    
    init(
        service: OpenAIService = OpenAIServiceFactory.service(baseURL: OLLAMA_BASE_URL)
    ) {
        self.service = service
    }
    
    func configure(viewModel: AcademiaViewModel) -> Ollama{
        self.viewModel = viewModel
        
        return self
    }
    
    func execute(prompt: String = "hello, how are you?") async {
        self.viewModel!.onLoading()
        let parameters = ChatCompletionParameters(messages: [.init(role: .user, content: .text(prompt))], model: .custom("llama3"))
        try? await startStreamedChat(parameters: parameters)
    }
    
    func startStreamedChat(
       parameters: ChatCompletionParameters) async throws
    {
       streamTask = Task {
             do {
                 let stream = try await service.startStreamedChat(parameters: parameters)
                 for try await result in stream {
                    let content = result.choices.first?.delta.content ?? ""
                     self.viewModel!.rcvMessage(from: content)
                 }
             } catch APIError.responseUnsuccessful(let description, let statusCode) {
                 self.viewModel!.rcvError(from: "Network error with status code: \(statusCode) and description: \(description)")
             } catch {
                 self.viewModel!.rcvError(from: error.localizedDescription)
             }
             self.viewModel!.onLoaded()
       }
    }
    
    func cancelStream() {
       streamTask?.cancel()
    }
    
    /// Embeddings functionality
    
    static let EMBEDDINGS_MODEL: String = "mxbai-embed-large"
    
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
    
    func registerEmbeddings(embd: EmbeddingResponse, doc: Int, prompt: String){
        embeddingsNodes.append(EmbeddingNode(id: String(doc), embeddings: embd.embeddings, documents: prompt))
        if(embeddingsNodes.count == sequencies.count) {
            Task{
                await onLoadedEmbds()
            }
        }
    }
    
    func requestEmbd(prompt: String) -> URLRequest {
        var request = URLRequest(
            url: URL(string:  Ollama.OLLAMA_BASE_URL + Ollama.EMBEDDINGS)!
        )
        request.httpMethod = "POST"
        let data = try! JSONEncoder().encode(
            EmbeddingRequest(model: Ollama.EMBEDDINGS_MODEL, input: prompt)
        )
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    /// RAG
    
    let sequencies: [String] = [
      /*"Llamas are members of the camelid family meaning they're pretty closely related to vicuñas and camels",
      "Llamas were first domesticated and used as pack animals 4,000 to 5,000 years ago in the Peruvian highlands",
      "Llamas can grow as much as 6 feet tall though the average llama between 5 feet 6 inches and 5 feet 9 inches tall",
      "Llamas weigh between 280 and 450 pounds and can carry 25 to 30 percent of their body weight",
      "Llamas are vegetarians and have very efficient digestive systems",*/
      "Llamas live to be about 99 years old, though some only live for 11 years and others live to be 22 years old"
    ]
    
    func onLoadedEmbds() async {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(embeddingsNodes)
        
        let embd = String(data: data, encoding: .utf8)!
        let input = "How long do llamas live?"
        var prompt: String = "Using this data: \(embd). Respond to this prompt: [\(input)]"
    }

}
