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
    case fileNotFound
    case jsonParsingError(String)
    
    var errorDescription: String? {
        switch self {
        case .errorDecoding:
            return "Failed to decode the response from the server. Please try again later."
        case .unkownError:
            return "An unexpected error occurred. Please try again later."
        case .invalidUrl:
            return "The request URL is invalid. Please check your internet connection and try again."
        case .serverError(let error):
            return "Server error: \(error)"
        case .fileNotFound:
            return "The requested file was not found in the app bundle."
        case .jsonParsingError(let details):
            return "Failed to parse server response: \(details)"
        }
    }
}
