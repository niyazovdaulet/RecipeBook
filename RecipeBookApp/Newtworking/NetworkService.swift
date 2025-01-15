//
//  NetworkService.swift
//  RecipeBookApp
//
//  Created by Daulet on 31/10/2023.
//

import Foundation

struct NetworkService {
    
    static let shared = NetworkService()
    
    private init() {}
    
    func fetchAllCategories(completion: @escaping (Result<AllDishes, Error>) -> Void) {
        // Locate the JSON file in the app bundle
        guard let path = Bundle.main.path(forResource: "data", ofType: "json") else {
            completion(.failure(AppError.fileNotFound))
            return
        }
        
        do {
            // Load the file content into a Data object
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: path))
            
            // Decode the JSON data into the AllDishes model
            let decoder = JSONDecoder()
            let allDishes = try decoder.decode(AllDishes.self, from: jsonData)
            
            // Return the decoded data via the completion handler
            completion(.success(allDishes))
        } catch {
            // Handle and return any decoding or file reading errors
            completion(.failure(AppError.errorDecoding))
        }
    }


    
    func addFavorite(dishId: String, completion: @escaping(Result<Favorite, Error>) -> Void) {
        request(route: .addFavorite(dishId), method: .post, completion: completion)
    }
    
    func fetchCategoryDishes(categoryId: String, completion: @escaping (Result<[Dish], Error>) -> Void) {
        // Locate the local JSON file in the bundle
        guard let path = Bundle.main.path(forResource: "data", ofType: "json") else {
            completion(.failure(NSError(domain: "FileNotFound", code: -1, userInfo: nil)))
            return
        }

        do {
            // Read the file content
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            // Decode the JSON data into the `AllDishes` struct
            let allDishes = try JSONDecoder().decode(AllDishes.self, from: data)
            
            // Assuming category dishes are stored in `populars` or `specials`
            let filteredDishes = allDishes.populars?.filter { $0.id == categoryId } ?? []
            completion(.success(filteredDishes))
        } catch {
            completion(.failure(error))
        }
    }

    
    func fetchFavorites(completion: @escaping (Result<[Favorite], Error>) -> Void) {
        // Example: Returning hardcoded favorites
        let sampleFavorites = [
            Favorite(id: "1", dish: Dish(id: "1", name: "Pancakes", description: "Delicious breakfast", image: "https://picsum.photos/200/200", calories: 350))
        ]
        completion(.success(sampleFavorites))
    }

    
    private func request<T: Decodable>(route: Route,
                                     method: Method,
                                     parameters : [String: Any]? = nil,
                                     completion: @escaping(Result<T, Error>) -> Void) {
        guard let request = createRequest(route: route, method: method, parameters: parameters)  else {
            completion(.failure(AppError.unkownError))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            var result: Result<Data, Error>?
            if let data = data {
                result = .success(data)
                let responseString = String(data: data, encoding: .utf8) ?? "Could not stringify our data"
//                print("The response is:\n\(responseString)")
            } else if let error = error {
                result = .failure(error)
                print("The error is: \(error.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                self.handleResponse(result: result, completion: completion)
            }
        }.resume()
    }
    
    private func handleResponse<T: Decodable>(result: Result<Data, Error>?,
                                              completion: (Result<T, Error>) -> Void)  {
        guard let result = result else {
            completion(.failure(AppError.unkownError))
            return
        }
        switch result {
        case .success(let data):
            let decoder = JSONDecoder()
            guard let response = try? decoder.decode(APIResponse<T>.self, from: data) else {
                completion(.failure(AppError.errorDecoding))
                return
            }
            if let error = response.error {
                completion(.failure(AppError.serverError(error)))
                return
            }
            if let decodedData = response.data {
                completion(.success(decodedData))
            } else {
                completion(.failure(AppError.unkownError))
            }
                
            
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    private func createRequest(route: Route, 
                               method: Method,
                                parameters: [String: Any]? = nil) -> URLRequest? {
        let urlString = Route.baseUrl + route.description
        guard let url = urlString.asUrl else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        
        if let params = parameters {
            switch method {
            case .get:
                var urlComponent =  URLComponents(string: urlString)
                urlComponent?.queryItems = params.map {
                    URLQueryItem(name: $0, value: "\($1)") }
                urlRequest.url = urlComponent?.url
            case .post, .delete, .patch:
                let bodyDate = try? JSONSerialization.data(withJSONObject: params, options: [])
            }
        }
        return urlRequest
    }
}
