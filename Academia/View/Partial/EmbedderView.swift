//
//  EmbedderView.swift
//  Academia
//
//  Created by Dave on 18/02/25.
//

import SwiftUI

struct EmbedderView: View {
    
    let viewModel: AcademiaViewModel
    
    @State private var enableRAG: Bool = false
    @State private var context: String = ""
    
    var body: some View {
        VStack {
            Toggle("Enable RAG", isOn: $enableRAG)
                .foregroundColor(.blue)
            if(enableRAG) {
                TextField(
                    "Insert data to embed in prompt",
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
