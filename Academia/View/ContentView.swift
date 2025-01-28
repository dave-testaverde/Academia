//
//  ContentView.swift
//  Academia
//
//  Created by Dave on 21/01/25.
//

import SwiftUI

struct ContentView: View {
    
    @State
    var viewModel: AcademiaViewModel = AcademiaViewModel()
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        VStack {
            Button("Generate with OLLAMA 3", systemImage: "lasso.badge.sparkles")
            {
                Task{
                    await viewModel.testOllama(
                        prompt: Assistant.generateQuiz(of: "interview question for android developer")
                    )
                }
            }.buttonStyle(BorderlessButtonStyle())
                .padding(.horizontal, 20)
                .padding(.vertical, 7)
                .foregroundColor(.white)
                .background(Color.accentColor)
                .cornerRadius(12)
            
            ScrollView {
                Text((viewModel.message.isEmpty) ? "" : ">> \(viewModel.message)")
            }
            
            if(viewModel.state == .loaded){
                if(Factory.generateQuiz(from: viewModel.message) != nil){
                    HStack{
                        QuizView(
                            quiz: Factory.generateQuiz(from: viewModel.message)!
                        )
                    }
                } else {
                    Text("Unable to load JSON")
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
