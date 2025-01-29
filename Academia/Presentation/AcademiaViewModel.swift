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
    var errorMessage: String = ""
    
    var state: StateApp = .idle
    
    func rcvMessage(from message: String){
        self.message += message
    }
    
    func rcvError(from error: String){
        self.errorMessage = error
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
