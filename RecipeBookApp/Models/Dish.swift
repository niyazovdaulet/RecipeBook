//
//  Dish.swift
//  RecipeBookApp
//
//  Created by Daulet on 27/10/2023.
//

import Foundation

struct Dish: Codable {
    let id, name, description, image: String?
    let calories: Int?
    
    var formattedcalories: String {
        return "\(calories ?? 0) calories"
    }
}
