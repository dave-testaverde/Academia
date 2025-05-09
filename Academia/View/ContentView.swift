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
    
    var body: some View {
        @Bindable var viewModel = viewModel
        @Bindable var ollama = ollama.configure(viewModel: viewModel)
        
        VStack {
            TextField(
                "Insert topic (e.g. question about geography)",
                text: $viewModel.prompt.context
            )
            .foregroundColor(.blue)
            .padding(4)
            .padding(.horizontal, 5)
            .overlay(
                RoundedRectangle(cornerRadius: 9)
                    .stroke(Color.blue, lineWidth: 2)
            )
            .padding(.bottom, 5)
            
            VStack {
                Slider(
                    value: $viewModel.prompt.difficulty,
                    in: 1...10,
                    step: 1
                )
                Text("Difficulty \(Int(viewModel.prompt.difficulty))")
                    .foregroundColor(.blue)
            }
            
            EmbedderView()
            
            Divider().background(.blue).padding(.bottom, 15)
            
            Button("Generate with OLLAMA 3", systemImage: "lasso.badge.sparkles"){
                if(viewModel.state != .loading){
                    Task {
                        try await ollama.onTapGeneration()
                    }
                }
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(.horizontal, 20)
            .padding(.vertical, 7)
            .foregroundColor(.white)
            .background(Color.accentColor)
            .cornerRadius(12)
            .padding(.bottom, 10)
            
            HStack{
                ScrollView {
                    Text((viewModel.message.isEmpty) ? "" : ">> \(viewModel.message)")
                }
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
                quizModule()
            }
            
            VStack {}
            .sheet(isPresented: $viewModel.onError, onDismiss: didDismiss) {
                VStack {
                    Text("Error occured!")
                        .font(.title)
                        .padding(50)
                    Text(viewModel.errorMsg)
                        .padding(50)
                    HStack(alignment: VerticalAlignment.center) {
                        Button("Close", action: didDismiss)
                    }
                }
            }
        }
        .padding()
    }
    
    func didDismiss() {
        // Handle the dismissing action.
        viewModel.onError = false
    }
    
    func quizModule() -> AnyView {
        if let quiz = viewModel.quiz {
            return AnyView(
                HStack{
                    QuizView(
                        quiz: quiz
                    )
                }
            )
        } else {
            return AnyView(Text("Unable to load JSON"))
        }
    }
}

#Preview {
    ContentView()
        .environment(AcademiaViewModel())
        .environment(Ollama())
}
