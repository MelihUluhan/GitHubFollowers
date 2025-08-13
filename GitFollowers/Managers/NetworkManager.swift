//
//  NetworkManager.swift
//  GitFollowers
//
//  Created by Melih Bey on 27.05.2025.
//

import UIKit


class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://api.github.com/users/"
    let cache = NSCache<NSString, UIImage>()
    let decoder = JSONDecoder()
    
    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    //    func getFollowers(for username:String, page: Int, completed: @escaping (Result<[Follower], GFError>) -> Void) {
    //        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
    //
    //        guard let url = URL(string: endpoint) else {
    //            completed(.failure(.invalidUsername))
    //            return
    //        }
    //
    //        let task = URLSession.shared.dataTask(with: url) { data, response, error in
    //            if let _ = error {
    //                completed(.failure(.unableToComplete))
    //            }
    //
    //            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
    //                completed(.failure(.invalidResponse))
    //                return
    //            }
    //
    //            guard let data = data else {
    //                completed(.failure(.invalidData))
    //                return
    //            }
    //
    //            do {
    //                let decoder = JSONDecoder()
    //                decoder.keyDecodingStrategy = .convertFromSnakeCase
    //                let followers = try decoder.decode([Follower].self, from: data)
    //                completed(.success(followers))
    //            } catch {
    //                completed(.failure(.invalidData))
    //            }
    //        }
    //
    //        task.resume()
    //    }
    
    func getFollowers(for username:String, page: Int) async throws -> [Follower] {
        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            throw GFError.invalidUsername
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GFError.invalidResponse
        }
        
        do {
            return try decoder.decode([Follower].self, from: data)
        } catch {
            throw GFError.invalidData
        }
    }
    
    func getUserInfo(for username:String) async throws -> User  {
        let endpoint = baseURL + "\(username)"
        
        guard let url = URL(string: endpoint) else {
            throw GFError.invalidUsername
        }
        
        let (data,response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GFError.invalidResponse
        }
        
        do {
            return try decoder.decode(User.self, from: data)
        } catch {
            throw GFError.invalidData
        }
    }
    
    func getUserRepos(for username:String) async throws -> [Repositories] {
        let endpoint = baseURL + "\(username)/repos"
        
        guard let url = URL(string: endpoint) else {
            throw GFError.invalidUsername
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GFError.invalidResponse
        }
        
        do {
            return try decoder.decode([Repositories].self, from: data)
        } catch {
            throw GFError.invalidData
        }
    }
    
    //    func getUserInfo(for username:String, completed: @escaping (Result<User, GFError>) -> Void) {
    //        let endpoint = baseURL + "\(username)"
    //
    //        guard let url = URL(string: endpoint) else {
    //            completed(.failure(.invalidUsername))
    //            return
    //        }
    //
    //        let task = URLSession.shared.dataTask(with: url) { data, response, error in
    //            if let _ = error {
    //                completed(.failure(.unableToComplete))
    //            }
    //
    //            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
    //                completed(.failure(.invalidResponse))
    //                return
    //            }
    //
    //            guard let data = data else {
    //                completed(.failure(.invalidData))
    //                return
    //            }
    //
    //            do {
    //                let decoder = JSONDecoder()
    //                decoder.keyDecodingStrategy = .convertFromSnakeCase
    //
    //                let user = try decoder.decode(User.self, from: data)
    //                completed(.success(user))
    //            } catch {
    //                completed(.failure(.invalidData))
    //            }
    //        }
    //
    //        task.resume()
    //    }
    
    func downloadImage(from urlString: String) async -> UIImage? {
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) { return image }
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            cache.setObject(image, forKey: cacheKey)
            return image
            
        } catch {
            return nil
        }
    }

//    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
//        let cacheKey = NSString(string: urlString)
//        if let image = cache.object(forKey: cacheKey) {
//            completed(image)
//            return
//        }
//
//        guard let url = URL(string: urlString) else {
//            completed(nil)
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
//            guard let self = self,
//                  error == nil,
//                  let response = response as? HTTPURLResponse, response.statusCode == 200,
//                  let data = data,
//                  let image = UIImage(data: data) else {
//                completed(nil)
//                return
//            }
//
//            self.cache.setObject(image, forKey: cacheKey)
//            completed(image)
//        }
//
//        task.resume()
//    }
}
