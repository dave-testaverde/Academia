//
//  Ollama.swift
//  Academia
//
//  Created by Dave on 29/01/25.
//

import Foundation
import SwiftOpenAI

@Observable
class Ollama {
    private static let OLLAMA_BASE_URL: String = "http://localhost:11434"
    private var streamTask: Task<Void, Never>? = nil
    
    let service: OpenAIService
    var viewModel: AcademiaViewModel?
    
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
}
