//
//  Route.swift
//  RecipeBookApp
//
//  Created by Daulet on 31/10/2023.
//

import Foundation

enum Route {
    static let baseUrl = "https://yummie.glitch.me/"
    
    case fetchAllCategories
    case addFavorite(String)
    case fetchCategoryDishes(String)
    case fetchFavorites
    
    var description: String {
        switch self {
        case .fetchAllCategories: 
            return "/dish-categories"
        case .addFavorite(let dishId): 
            return "/orders/\(dishId)"
        case .fetchCategoryDishes(let categoryId): 
            return "/dishes/\(categoryId)"
        case .fetchFavorites:
            return "/orders"
            
        }
    }
}

