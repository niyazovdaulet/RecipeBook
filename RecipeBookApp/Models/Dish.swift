

import Foundation

struct Dish: Codable, Equatable {
    let id, name, origin, image: String?
    let ingredients: [String]?
    let measures: [String]?
    let instructions: String?
    let youtubeUrl: String?
    
    // Implement Equatable
    static func == (lhs: Dish, rhs: Dish) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}
