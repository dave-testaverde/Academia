//
//  GetNetworkError.swift
//  Academia
//
//  Created by Dave on 21/03/25.
//

import Foundation

enum GetNetworkError: AppError {
    var id: Self { self }
    
    case error(cause: String)
    
    var errorDescription: String? {
        switch self {
            case .error(let cause):
                return cause
        }
    }
}
