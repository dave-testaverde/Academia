//
//  PDFReaderView.swift
//  Academia
//
//  Created by Dave on 01/03/25.
//

import SwiftUI
import PDFKit

struct PDFReaderView: View {
    let url = Bundle.main.url(forResource: "data_llama", withExtension: "pdf")!

    var body: some View {
        VStack{
            PDFKitView(url:  url)
            Text(PDF2text(url: url))
        }
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
    
    func updateUIView(_ pdfView: PDFView, context: Context) {}
}

#Preview {
    PDFReaderView()
}
