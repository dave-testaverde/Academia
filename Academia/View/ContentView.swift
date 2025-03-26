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
            
            Button("Generate with OLLAMA 3", systemImage: "lasso.badge.sparkles")
            {
                if(viewModel.state != .loading){
                    Task {
                        try await ollama.onTapGeneration()
                    }
                }
            }.buttonStyle(BorderlessButtonStyle())
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
                if(Factory.generateQuiz(from: viewModel.message, viewModel: viewModel) != nil){
                    HStack{
                        QuizView(
                            quiz: Factory.generateQuiz(from: viewModel.message, viewModel: viewModel)!
                        )
                    }
                } else {
                    Text("Unable to load JSON")
                }
            }
            
            /*VStack {}
            .sheet(item: $viewModel.getUploadError) { error in
                Text(error.localizedDescription)
                    .onAppear {
                        viewModel.onError(err: error)
                    }
            }
            .sheet(item: $viewModel.getDecodingError) { error in
                Text(error.localizedDescription)
                    .onAppear {
                        viewModel.onError(err: error)
                    }
            }
            .sheet(item: $viewModel.getNetworkError) { error in
                Text(error.localizedDescription)
                    .onAppear {
                        viewModel.onError(err: error)
                    }
            }*/
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .environment(AcademiaViewModel())
        .environment(Ollama())
}
