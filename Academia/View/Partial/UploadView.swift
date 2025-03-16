//
//  UploadView.swift
//  Academia
//
//  Created by Dave on 07/03/25.
//

import SwiftUI

struct UploadView : View {
    
    @Environment(AcademiaViewModel.self) var viewModel
    @State private var presentImporter = false
    
    var body: some View {
        @Bindable var viewModel = viewModel
        HStack{
            Button("Upload PDF") {
                presentImporter = true
            }.fileImporter(isPresented: $presentImporter, allowedContentTypes: [.pdf]) { result in
                switch result {
                    case .success(let url):
                        print("file uploaded: \(url)")
                        viewModel.pdfFileUrl = url
                    case .failure(let error):
                        print(error)
                }
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(.horizontal, 20)
            .padding(.vertical, 7)
            .foregroundColor(.white)
            .background(Color.accentColor)
            .cornerRadius(12)
            
            if(viewModel.pdfFileUrl != nil){
                Text(viewModel.pdfFileUrl!.lastPathComponent)
                    .foregroundColor(.blue)
            }
        }
    }
}

#Preview {
    UploadView()
        .environment(AcademiaViewModel())
}
