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
    static let LLM3_MODEL: String = "llama3"
    static let EMBEDDINGS_MODEL: String = "mxbai-embed-large"
    
    static let OLLAMA_BASE_URL: String = "http://localhost:11434"
    static let LLM: String = "/api/generate"
    static let EMBEDDINGS: String = "/api/embed"
    
    /// RAG features consume a lot of resources: size this parameter
    static let REQUEST_MAX_TIMEOUT: Double = 30000
    
    private var streamTask: Task<Void, Never>? = nil
    
    let service: OpenAIService
    var viewModel: AcademiaViewModel?
    
    var embeddings: Embeddings = Embeddings()
    
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
        let parameters = ChatCompletionParameters(messages: [.init(role: .user, content: .text(prompt))], model: .custom(Ollama.LLM3_MODEL))
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
}
