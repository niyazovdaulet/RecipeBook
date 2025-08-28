import Foundation

struct DishCategory: Codable, Equatable {
    let id: String?
    let name: String?
    let image: String?
    let dishes: [Dish]?
    
    // Implement Equatable
    static func == (lhs: DishCategory, rhs: DishCategory) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}
