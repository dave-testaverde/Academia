//
//  AcademiaViewModel.swift
//  Academia
//
//  Created by Dave on 21/01/25.
//

import Foundation
import SwiftOpenAI

@Observable
class AcademiaViewModel {
    private static let OLLAMA_BASE_URL: String = "http://localhost:11434"
    private var streamTask: Task<Void, Never>? = nil
    
    let service: OpenAIService
    
    var message: String = ""
    var errorMessage: String = ""
    
    init(service: OpenAIService = OpenAIServiceFactory.service(baseURL: OLLAMA_BASE_URL)) {
        self.service = service
    }
    
    func testOllama(prompt: String = "hello, how are you?") async {
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
                     self.message += content
                 }
             } catch APIError.responseUnsuccessful(let description, let statusCode) {
                 self.errorMessage = "Network error with status code: \(statusCode) and description: \(description)"
             } catch {
                 self.errorMessage = error.localizedDescription
             }
       }
    }
    
    func cancelStream() {
       streamTask?.cancel()
    }
    
}
