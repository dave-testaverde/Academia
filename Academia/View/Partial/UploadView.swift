//
//  UploadView.swift
//  Academia
//
//  Created by Dave on 07/03/25.
//

import SwiftUI

struct UploadView : View {
    @State private var presentImporter = false
    
    var body: some View {
        Button("Upload PDF") {
            presentImporter = true
        }.fileImporter(isPresented: $presentImporter, allowedContentTypes: [.pdf]) { result in
            print(result)
        }
    }
}

#Preview {
    UploadView()
}
