//
//  EmbedderView.swift
//  Academia
//
//  Created by Dave on 18/02/25.
//

import SwiftUI

struct EmbedderView: View {
    
    let viewModel: AcademiaViewModel
    
    @State private var showModal = false
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        VStack {
            Toggle("Enable RAG", isOn: $viewModel.enableRAG)
                .foregroundColor(.blue)
            if(viewModel.enableRAG) {
                TextField(
                    "Insert data to embed in prompt",
                    text: $viewModel.contextRAG,
                    axis: .vertical
                )
                .lineLimit(3...10)
                .foregroundColor(.blue)
                .padding(4)
                .padding(.horizontal, 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 9)
                        .stroke(Color.blue, lineWidth: 2)
                )
                .padding(.bottom, 5)
                Toggle("Enable Docs", isOn: $viewModel.enableDocs)
                    .foregroundColor(.blue)
                if(viewModel.enableDocs) {
                    Button("Show default docs") {
                      showModal = true
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    EmbedderView(
        viewModel: AcademiaViewModel()
    )
}
