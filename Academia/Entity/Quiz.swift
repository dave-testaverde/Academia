//
//  Quiz.swift
//  Academia
//
//  Created by Dave on 24/01/25.
//

class Quiz: Decodable, Identifiable {
    let question: String
    let answers: [String]
    let correct: Int
    
    init(question: String, answers: [String], correct: Int) {
        self.question = question
        self.answers = answers
        self.correct = correct
    }
}
