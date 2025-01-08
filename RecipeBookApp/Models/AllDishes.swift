//
//  AllDishes.swift
//  RecipeBookApp
//
//  Created by Daulet on 01/11/2023.
//

import Foundation

struct AllDishes: Decodable {
    let categories: [DishCategory]?
    let populars: [Dish]?
    let specials: [Dish]?
}
