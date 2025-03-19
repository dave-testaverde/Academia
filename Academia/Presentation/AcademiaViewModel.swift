//
//  AcademiaViewModel.swift
//  Academia
//
//  Created by Dave on 21/01/25.
//

import Foundation
import SwiftOpenAI

enum StateApp {
    case idle
    case loading
    case loaded
}

@Observable
class AcademiaViewModel {
    var message: String = ""
    
    var getUploadError: GetUploadError?
    
    var state: StateApp = .idle
    
    var prompt: Prompt = Prompt(difficulty: 1.0, context: "How long do llamas live?")
    
    var enableRAG: Bool = false
    var contextRAG: String = "Llamas live to be about 21 years old, though some only live for 16 years and others live to be 31 years old"
    
    var enableDocs: Bool = false
    
    var pdfFileUrl: URL?
    
    func rcvMessage(from message: String){
        self.message += message
    }
    
    /// Events
    
    func onLoaded(){
        self.state = .loaded
    }
    
    func onLoading(){
        self.state = .loading
        self.message = ""
    }
}
