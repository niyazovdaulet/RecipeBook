import Foundation

struct DishCategory: Codable {
    let id: String?
    let name: String?
    let image: String?
    let dishes: [Dish]?
}
