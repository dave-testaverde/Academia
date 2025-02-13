//
//  Embedding.swift
//  Academia
//
//  Created by Dave on 06/02/25.
//

struct Embedding: Decodable {
    let model: String
    var embeddings: [[Double]]
    var total_duration: Int
    var load_duration: Int
    var prompt_eval_count: Int
}

struct EmbeddingRequest: Encodable {
    let model: String
    let input: String
}

struct EmbeddingNode: Encodable {
    let id: String
    let embeddings: String
    let documents: String
}
