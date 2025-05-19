import Foundation

class FavoritesManager {
    static let shared = FavoritesManager()
    private let favoritesKey = "favorites"
    
    private init() {}
    
    // Save a new favorite
    func addFavorite(dish: Dish) {
        var favorites = getAllFavorites()
        
        // Check if dish is already in favorites
        if !favorites.contains(where: { $0.dish?.id == dish.id }) {
            let newFavorite = Favorite(id: UUID().uuidString, dish: dish)
            favorites.append(newFavorite)
            saveFavorites(favorites)
        }
    }
    
    // Remove a favorite
    func removeFavorite(dishId: String) {
        var favorites = getAllFavorites()
        favorites.removeAll { $0.dish?.id == dishId }
        saveFavorites(favorites)
    }
    
    // Get all favorites
    func getAllFavorites() -> [Favorite] {
        guard let data = UserDefaults.standard.data(forKey: favoritesKey) else {
            return []
        }
        
        do {
            let favorites = try JSONDecoder().decode([Favorite].self, from: data)
            return favorites
        } catch {
            print("Error decoding favorites: \(error)")
            return []
        }
    }
    
    // Check if a dish is in favorites
    func isFavorite(dishId: String) -> Bool {
        let favorites = getAllFavorites()
        return favorites.contains { $0.dish?.id == dishId }
    }
    
    // Private method to save favorites
    private func saveFavorites(_ favorites: [Favorite]) {
        do {
            let data = try JSONEncoder().encode(favorites)
            UserDefaults.standard.set(data, forKey: favoritesKey)
        } catch {
            print("Error encoding favorites: \(error)")
        }
    }
} 