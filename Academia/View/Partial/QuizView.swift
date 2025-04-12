//
//  QuizView.swift
//  Academia
//
//  Created by Dave on 26/01/25.
//

import SwiftUI

struct QuizView: View {
    
    let quiz: Quiz
    
    @State
    private var correctVisible: Bool = false
    
    var body: some View {
        VStack {
            Text(quiz.question)
            List {
                ForEach(quiz.answers, id: \.self){ answer in
                    Text("\(answer)")
                        .foregroundStyle(
                            (correctVisible) ? ((answer == quiz.answers[quiz.correct]) ? .green : .black) : .black
                        )
                }
            }
            Toggle("Show correct answer", isOn: $correctVisible)
        }
        .padding()
        .frame(minHeight: 300)
    }
}

#Preview {
    QuizView(
        quiz: QuizManager.quizMock
    )
}
