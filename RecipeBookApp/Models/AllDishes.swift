//
//  AllDishes.swift
//  RecipeBookApp
//
//  Created by Daulet on 01/11/2023.
//

import Foundation

struct AllDishes: Codable {
    let categories: [DishCategory]?
    let populars: [Dish]?
    let specials: [Dish]?
}
