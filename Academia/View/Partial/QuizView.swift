//
//  QuizView.swift
//  Academia
//
//  Created by Dave on 26/01/25.
//

import SwiftUI

struct QuizView: View {
    
    var quiz: Quiz
    
    var body: some View {
        VStack {
            Text(quiz.question)
            List {
                ForEach(quiz.answer, id: \.self){ answer in
                    Text ("\(answer)")
                }
            }
        }
        .padding()
    }
}

#Preview {
    QuizView(
        quiz: Quiz(question: "?", answer: ["A", "B", "C", "D"], correct: 1)
    )
}
