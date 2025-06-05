import Foundation

// Response for category list
struct MealDBCategoryResponse: Codable {
    let categories: [MealDBCategory]
}

struct MealDBCategory: Codable {
    let idCategory: String
    let strCategory: String
    let strCategoryThumb: String
    let strCategoryDescription: String
}

// Response for meals in a category
struct MealDBMealsResponse: Codable {
    let meals: [MealDBMeal]?
}

struct MealDBMeal: Codable {
    let idMeal: String
    let strMeal: String
    let strArea: String
    let strMealThumb: String
    let strInstructions: String
    let strIngredient1: String?
    let strIngredient2: String?
    let strIngredient3: String?
    let strIngredient4: String?
    let strIngredient5: String?
    let strIngredient6: String?
    let strIngredient7: String?
    let strIngredient8: String?
    let strIngredient9: String?
    let strIngredient10: String?
    let strIngredient11: String?
    let strIngredient12: String?
    let strIngredient13: String?
    let strIngredient14: String?
    let strIngredient15: String?
    let strIngredient16: String?
    let strIngredient17: String?
    let strIngredient18: String?
    let strIngredient19: String?
    let strIngredient20: String?
    
    var ingredients: String {
        var ingredientsList: [String] = []
        
        // Helper function to add non-nil ingredients
        func addIngredient(_ ingredient: String?) {
            if let ingredient = ingredient, !ingredient.isEmpty {
                ingredientsList.append(ingredient)
            }
        }
        
        // Add all possible ingredients
        addIngredient(strIngredient1)
        addIngredient(strIngredient2)
        addIngredient(strIngredient3)
        addIngredient(strIngredient4)
        addIngredient(strIngredient5)
        addIngredient(strIngredient6)
        addIngredient(strIngredient7)
        addIngredient(strIngredient8)
        addIngredient(strIngredient9)
        addIngredient(strIngredient10)
        addIngredient(strIngredient11)
        addIngredient(strIngredient12)
        addIngredient(strIngredient13)
        addIngredient(strIngredient14)
        addIngredient(strIngredient15)
        addIngredient(strIngredient16)
        addIngredient(strIngredient17)
        addIngredient(strIngredient18)
        addIngredient(strIngredient19)
        addIngredient(strIngredient20)
        
        return ingredientsList.joined(separator: ", ")
    }
    
    // Convert to our app's Dish model
    func toDish() -> Dish {
        return Dish(
            id: idMeal,
            name: strMeal,
            description: "Ingredients: \(ingredients)\n\nInstructions: \(strInstructions)",
            origin: strArea,
            image: strMealThumb
        )
    }
}

// Lightweight model for filter.php?c=... response
struct MealDBFilterMeal: Codable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    let strArea: String?
    let strCategory: String?
}

struct MealDBFilterMealsResponse: Codable {
    let meals: [MealDBFilterMeal]?
} 
