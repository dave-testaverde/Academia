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
            Image(systemName: "lasso.badge.sparkles")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Button(action: {
                Task{
                    await viewModel.testOllama(prompt: makeAutoQuiz)
                }
            }) {
                Text("Test OLLAMA 3")
            }
            ScrollView {
                Text((viewModel.message.isEmpty) ? "" : ">> \(viewModel.message)")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
