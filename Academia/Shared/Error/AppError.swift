//
//  AppError.swift
//  Academia
//
//  Created by Dave on 19/03/25.
//

import Foundation

protocol AppError: Error, Hashable, Identifiable, Equatable, LocalizedError {}
