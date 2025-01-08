//
//  DishCategory.swift
//  RecipeBookApp
//
//  Created by Daulet on 26/10/2023.
//

import Foundation

struct DishCategory: Decodable {
    let id, name, image: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "title"
        case image
    }
}


