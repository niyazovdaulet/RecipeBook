//
//  APIResponse.swift
//  RecipeBookApp
//
//  Created by Daulet on 31/10/2023.
//

import Foundation

struct APIResponse<T: Decodable>: Decodable {
    let status: Int
    let message: String?
    let data: T?
    let error: String?
}
