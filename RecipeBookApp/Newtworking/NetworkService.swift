
import Foundation

class NetworkService {
    
    static let shared = NetworkService()
    
    private init() {}
    
    // Rate limiting properties
    private var lastRequestTime: Date = Date.distantPast
    private let minimumRequestInterval: TimeInterval = 0.5 // 500ms between requests
    
    func fetchAllCategories(completion: @escaping (Result<[DishCategory], Error>) -> Void) {
        request(route: .fetchAllCategories, method: .get) { (result: Result<MealDBCategoryResponse, Error>) in
            switch result {
            case .success(let response):
                // Convert MealDBCategory to DishCategory
                let categories = response.categories.map { category in
                    DishCategory(
                        id: category.idCategory,
                        name: category.strCategory,
                        image: category.strCategoryThumb,
                        dishes: nil // We'll fetch dishes when needed
                    )
                }
                completion(.success(categories))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchCategoryDishes(category: String, completion: @escaping (Result<[Dish], Error>) -> Void) {
        request(route: .fetchCategoryDishes(category), method: .get) { (result: Result<MealDBFilterMealsResponse, Error>) in
            switch result {
            case .success(let response):
                guard let meals = response.meals else {
                    completion(.success([]))
                    return
                }
                // Fetch full details for each meal
                let group = DispatchGroup()
                var dishes: [Dish] = []
                var errors: [Error] = []
                for meal in meals {
                    group.enter()
                    self.fetchMealDetails(mealId: meal.idMeal) { result in
                        switch result {
                        case .success(let dish):
                            dishes.append(dish)
                        case .failure(let error):
                            errors.append(error)
                        }
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    if !errors.isEmpty && dishes.isEmpty {
                        completion(.failure(errors[0]))
                    } else {
                        completion(.success(dishes))
                    }
                }
            case .failure(let error):
                print("❌ Failed to fetch category dishes for '\(category)': \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func fetchMealDetails(mealId: String, completion: @escaping (Result<Dish, Error>) -> Void) {
        request(route: .fetchMealDetails(mealId), method: .get) { (result: Result<MealDBMealsResponse, Error>) in
            switch result {
            case .success(let response):
                guard let meal = response.meals?.first else {
                    completion(.failure(AppError.unkownError))
                    return
                }
                completion(.success(meal.toDish()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func request<T: Decodable>(route: Route,
                                     method: Method,
                                     parameters: [String: Any]? = nil,
                                     completion: @escaping(Result<T, Error>) -> Void) {
        guard let url = URL(string: Route.baseUrl + route.description) else {
            completion(.failure(AppError.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Add rate limiting delay
        let now = Date()
        let timeSinceLastRequest = now.timeIntervalSince(lastRequestTime)
        let delay = max(0, minimumRequestInterval - timeSinceLastRequest)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self else { return }
            self.lastRequestTime = Date()
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        completion(.failure(AppError.unkownError))
                    }
                    return
                }
                
                // Handle rate limiting
                if httpResponse.statusCode == 429 {
                    print("⚠️ Rate limit hit for \(route.description), retrying in 2 seconds...")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.request(route: route, method: method, parameters: parameters, completion: completion)
                    }
                    return
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    DispatchQueue.main.async {
                        completion(.failure(AppError.serverError("Server returned status code \(httpResponse.statusCode)")))
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(AppError.unkownError))
                    }
                    return
                }
                
                // Print raw response for debugging
                if let jsonString = String(data: data, encoding: .utf8) {
//                    print("Raw response for \(route.description): \(jsonString)")
                }
                
                // Validate that the response is JSON
                guard let _ = try? JSONSerialization.jsonObject(with: data) else {
                    DispatchQueue.main.async {
                        completion(.failure(AppError.jsonParsingError("Response is not valid JSON")))
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    self.handleResponse(result: .success(data), completion: completion)
                }
            }.resume()
        }
    }
    
    private func handleResponse<T: Decodable>(result: Result<Data, Error>, completion: @escaping(Result<T, Error>) -> Void) {
        switch result {
        case .success(let data):
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(T.self, from: data)
                completion(.success(response))
            } catch let error as DecodingError {
                switch error {
                case .dataCorrupted(let context):
                    print("Data corrupted: \(context.debugDescription)")
                    completion(.failure(AppError.jsonParsingError("Data corrupted: \(context.debugDescription)")))
                case .keyNotFound(let key, let context):
                    print("Key not found: \(key.stringValue) - \(context.debugDescription)")
                    completion(.failure(AppError.jsonParsingError("Missing required field: \(key.stringValue)")))
                case .typeMismatch(let type, let context):
                    print("Type mismatch: expected \(type) - \(context.debugDescription)")
                    completion(.failure(AppError.jsonParsingError("Invalid data type for field: \(context.codingPath.last?.stringValue ?? "unknown")")))
                case .valueNotFound(let type, let context):
                    print("Value not found: expected \(type) - \(context.debugDescription)")
                    completion(.failure(AppError.jsonParsingError("Missing value for field: \(context.codingPath.last?.stringValue ?? "unknown")")))
                @unknown default:
                    print("Unknown decoding error: \(error)")
                    completion(.failure(AppError.jsonParsingError("Failed to decode response")))
                }
            } catch {
                print("Unexpected error: \(error)")
                completion(.failure(error))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    // Fetch all meals from all categories and return a flat list of unique Dish objects
    func fetchAllMealsFromAllCategories(completion: @escaping (Result<[Dish], Error>) -> Void) {
        fetchAllCategories { result in
            switch result {
            case .success(let categories):
                
                // Only fetch from a limited number of popular categories to prevent rate limiting
                let popularCategories = ["Chicken", "Beef", "Seafood", "Dessert", "Vegetarian"]
                let limitedCategories = categories.filter { category in
                    guard let name = category.name else { return false }
                    return popularCategories.contains(name)
                }
                
                
                let group = DispatchGroup()
                var allDishes: [Dish] = []
                var errors: [Error] = []
                var seenIds: Set<String> = []
                
                for (index, category) in limitedCategories.enumerated() {
                    guard let name = category.name else { continue }
                    group.enter()
                    
                    // Add delay between category requests to prevent rate limiting
                    let delay = Double(index) * 0.5
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        self.fetchCategoryDishes(category: name) { result in
                            switch result {
                            case .success(let dishes):
                                for dish in dishes {
                                    if let id = dish.id, !seenIds.contains(id) {
                                        allDishes.append(dish)
                                        seenIds.insert(id)
                                    }
                                }
                            case .failure(let error):
                                errors.append(error)
                            }
                            group.leave()
                        }
                    }
                }
                
                group.notify(queue: .main) {
                    if !errors.isEmpty && allDishes.isEmpty {
                        completion(.failure(errors[0]))
                    } else {
                        completion(.success(allDishes))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
