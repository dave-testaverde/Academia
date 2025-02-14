//
//  Generation.swift
//  Academia
//
//  Created by Dave on 14/02/25.
//

struct GenerationRequest: Encodable {
    let model: String
    let prompt: String
}

struct GenerationResponse: Decodable {
    let model: String
    let created_at: String
    let response: String
    let done: Bool
}
