//
//  PDF.swift
//  Academia
//
//  Created by Dave on 03/03/25.
//

import Foundation
import PDFKit

func PDF2text(url: URL = Bundle.main.url(forResource: "data_llama", withExtension: "pdf")!) -> String {
    var documentContent = ""
    if let pdf = PDFDocument(url: url) {
        let pageCount = pdf.pageCount

        for i in 0 ..< pageCount {
            guard let page = pdf.page(at: i) else { continue }
            guard let pageContent = page.attributedString else { continue }
            documentContent += pageContent.string.replacingOccurrences(of: "\n", with: "")
        }
    }
    return documentContent
}
