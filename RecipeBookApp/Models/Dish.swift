//
//  Dish.swift
//  RecipeBookApp
//
//  Created by Daulet on 27/10/2023.
//

import Foundation

struct Dish: Codable {
    let id, name, origin, image: String?
    let ingredients: [String]?
    let measures: [String]?
    let instructions: String?
}
