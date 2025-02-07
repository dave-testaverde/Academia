//
//  RuntimeError.swift
//  Academia
//
//  Created by Dave on 07/02/25.
//

import Foundation

struct RuntimeError: LocalizedError {
    let description: String

    init(_ description: String) {
        self.description = description
    }

    var errorDescription: String? {
        description
    }
}
