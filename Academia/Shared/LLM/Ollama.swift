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
    
    func createEmbeddings(prompt: String) async {
        var request = URLRequest(url: URL(string:  Ollama.OLLAMA_BASE_URL + Ollama.EMBEDDINGS)!)
        request.httpMethod = "POST"
        let data = try! JSONEncoder().encode(EmbeddingRequest(model: "mxbai-embed-large", input: prompt))
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlSession.dataTaskPublisher(for: request)
            .first()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    ()
                case .failure(let error):
                    print("Failed to Send POST Request \(error)")
                }
            }, receiveValue: { _, response in
                let statusCode = (response as! HTTPURLResponse).statusCode

                if statusCode == 200 {
                    print("200")
                } else {
                    print("FAILURE")
                }
            })
            .store(in: &cancellables)
    }

}
