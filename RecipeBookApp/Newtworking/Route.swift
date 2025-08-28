
import Foundation

enum Route {
    static let baseUrl = "https://www.themealdb.com/api/json/v1/1/"
    
    case fetchAllCategories
    case fetchCategoryDishes(String)
    case fetchMealDetails(String)
    
    var description: String {
        switch self {
        case .fetchAllCategories: 
            return "categories.php"
        case .fetchCategoryDishes(let category): 
            return "filter.php?c=\(category)"
        case .fetchMealDetails(let mealId):
            return "lookup.php?i=\(mealId)"
        }
    }
}

