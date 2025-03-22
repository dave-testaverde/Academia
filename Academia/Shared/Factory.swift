//
//  Factory.swift
//  Academia
//
//  Created by Dave on 27/01/25.
//

import Foundation

class Factory {
    static let quizMock = Quiz(question: "?", answers: ["A", "B", "C", "D"], correct: 1)
    
    static func generateQuiz(from json: String, viewModel: AcademiaViewModel) -> Quiz? {
        do {
            return try JSONDecoder().decode(Quiz.self, from: Data(json.utf8))
        } catch let err {
            viewModel.getDecodingError = GetDecodingError.error(cause: err.localizedDescription)
            print(err)
        }
        return nil
    }
    
    
}
