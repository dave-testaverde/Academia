//
//  QuizManager.swift
//  Academia
//
//  Created by Dave on 27/01/25.
//

import Foundation

class QuizManager {
    static let quizMock = Quiz(question: "?", answers: ["A", "B", "C", "D"], correct: 1)
    
    static func generateQuiz(from json: String, viewModel: AcademiaViewModel) {
        do {
            viewModel.quiz = try JSONDecoder().decode(Quiz.self, from: Data(json.utf8))
        } catch let err {
            viewModel.onError(err: GetDecodingError.error(cause: err.localizedDescription))
            print(err)
        }
    }
    
}
