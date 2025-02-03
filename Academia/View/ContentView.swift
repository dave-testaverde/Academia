//
//  ContentView.swift
//  Academia
//
//  Created by Dave on 21/01/25.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(AcademiaViewModel.self) var viewModel
    @Environment(Ollama.self) var ollama
    
    @State 
    private var context: String = "interview question for android developer"
    
    var body: some View {
        @Bindable var viewModel = viewModel
        @Bindable var ollama = ollama.configure(viewModel: viewModel)
        
        VStack {
            TextField(
                "Insert topic (e.g. question about geography)",
                text: $context
            )
            .foregroundColor(.blue)
            .padding(4)
            .padding(.horizontal, 5)
            .overlay(
                RoundedRectangle(cornerRadius: 9)
                    .stroke(Color.blue, lineWidth: 2)
            )
            .padding(.bottom, 5)
            
            Button("Generate with OLLAMA 3", systemImage: "lasso.badge.sparkles")
            {
                Task {
                    await ollama.execute(
                        prompt: Assistant.generateQuiz(of: context)
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
            
            if(viewModel.state == .loading){
                ProgressView {
                    HStack{
                        Image(systemName: "ellipsis.message").foregroundStyle(.blue)
                        Text("Generating quiz..").foregroundStyle(.blue)
                    }
                }.controlSize(.large).tint(.blue)
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
        .environment(AcademiaViewModel())
        .environment(Ollama())
}
