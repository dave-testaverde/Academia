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
    
    @State private var showModal = false
    
    var body: some View {
        @Bindable var viewModel = viewModel
        HStack{
            Button("Upload PDF") {
                presentImporter = true
            }.fileImporter(isPresented: $presentImporter, allowedContentTypes: [.pdf]) { result in
                switch result {
                    case .success(let url):
                        print("file uploaded: \(url)")
                        let gotAccess = url.startAccessingSecurityScopedResource()
                        if !gotAccess { return }
                        viewModel.pdfFileUrl = url
                        url.stopAccessingSecurityScopedResource()
                    case .failure(let error):
                        print(error)
                        viewModel.getUploadError = GetUploadError.error(cause: error.localizedDescription)
                }
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(.horizontal, 20)
            .padding(.vertical, 7)
            .foregroundColor(.white)
            .background(Color.accentColor)
            .cornerRadius(12)
            
            if(viewModel.pdfFileUrl != nil) {
                Button(viewModel.pdfFileUrl!.lastPathComponent){
                    showModal = true
                }.sheet(isPresented: $showModal) {
                    PDFReaderView(
                        url: viewModel.pdfFileUrl!
                    )
                }
            }
        }
    }
}

#Preview {
    UploadView()
        .environment(AcademiaViewModel())
}
