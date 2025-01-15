import Foundation

struct DishCategory: Decodable {
    let id: String?
    let name: String?
    let image: String?
    let dishes: [Dish]?
}
