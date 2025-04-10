//
//  AcademiaApp.swift
//  Academia
//
//  Created by Dave on 21/01/25.
//

import SwiftUI

@main
@MainActor
struct AcademiaApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(AcademiaViewModel())
                .environment(Ollama())
        }
    }
}
