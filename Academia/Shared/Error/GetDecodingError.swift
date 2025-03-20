//
//  GetDecodingError.swift
//  Academia
//
//  Created by Dave on 19/03/25.
//

import Foundation

enum GetDecodingError: AppError {
    var id: Self { self }
    
    case error(cause: String)
    
    var errorDescription: String? {
        switch self {
            case .error(let cause):
                return cause
        }
    }
}
