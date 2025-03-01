//
//  PDFReaderView.swift
//  Academia
//
//  Created by Dave on 01/03/25.
//

import SwiftUI
import PDFKit

struct PDFReaderView: View {
    // You need to add sample pdf in the app bundle.
    // Just drag and drop a pdf to the project.
    // Otherwise app will crash
    let url = Bundle.main.url(forResource: "data_llama", withExtension: "pdf")!

    var body: some View {
         PDFKitView(url:  url)
                 
    }
}

struct PDFKitView: UIViewRepresentable {
    
    let url: URL
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: self.url)
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: Context) {
        // Update pdf if needed
    }
}

#Preview {
    PDFReaderView()
}
