//
//  AppError.swift
//  RecipeBookApp
//
//  Created by Daulet on 31/10/2023.
//

import Foundation

enum AppError: LocalizedError {
    case errorDecoding
    case unkownError
    case invalidUrl
    case serverError(String)
    
    var errorDescription: String? {
        switch self {
        case .errorDecoding:
            return "response could not be decoded"
        case .unkownError:
            return "bruh, i have no idea what's going on"
        case .invalidUrl:
            return "Hey, give me a valid url"
        case .serverError(let error):
            return error
        }
    }
}
