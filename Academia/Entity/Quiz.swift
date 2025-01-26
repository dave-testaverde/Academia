//
//  Quiz.swift
//  Academia
//
//  Created by Dave on 24/01/25.
//

class Quiz: Decodable, Identifiable {
    let question: String
    let answer: [String]
    let correct: Int
    
    init(question: String, answer: [String], correct: Int) {
        self.question = question
        self.answer = answer
        self.correct = correct
    }
}
