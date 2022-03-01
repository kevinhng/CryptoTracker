//
//  CoinDataService.swift
//  CryptoTracker
//
//  Created by Kevin Hoàng on 01.03.22.
//

import Foundation

class CoinDataService {
    
    static let shared = CoinDataService()
    
    func getCoins(completion: @escaping (Result<[Coin], NetworkError>) -> Void) {
        // https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false&price_change_percentage=24h
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.coingecko.com"
        components.path = "/api/v3/coins/markets"
        components.queryItems = [
            URLQueryItem(name: "vs_currency", value: "usd"),
            URLQueryItem(name: "ids", value: nil),
            URLQueryItem(name: "category", value: nil),
            URLQueryItem(name: "order", value: "market_cap_desc"),
            URLQueryItem(name: "per_page", value: "100"),
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "sparkline", value: "false"),
            URLQueryItem(name: "price_change_percentage", value: "24h")
        ]
        
        guard let url = components.url else {
            preconditionFailure("Failed to construct URL.")
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.transportError(error)))
            }
            
            if let response = response as? HTTPURLResponse, !(response.statusCode >= 200 && response.statusCode < 300) {
                completion(.failure(.serverError(statusCode: response.statusCode)))
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let coins = try decoder.decode([Coin].self, from: data)
                completion(.success(coins))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        
        task.resume()
    }
    
    enum NetworkError: Error {
        case transportError(Error)
        case serverError(statusCode: Int)
        case noData
        case decodingError(Error)
    }
}
