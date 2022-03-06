//
//  MarketChartService.swift
//  CryptoTracker
//
//  Created by Kevin Hoàng on 04.03.22.
//

import Foundation

class MarketChartService {
    static let shared = MarketChartService()
    
    func getMarketData(for coin: Coin, days: ChartDays, completion: @escaping (Result<MarketChart, NetworkError>) -> Void) {
        
        // https://api.coingecko.com/api/v3/coins/ethereum/market_chart?vs_currency=usd&days=30&interval=daily
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.coingecko.com"
        components.path = "/api/v3/coins/\(coin.id)/market_chart"
        components.queryItems = [
            URLQueryItem(name: "vs_currency", value: "usd"),
            URLQueryItem(name: "days", value: days.urlValue),
            URLQueryItem(name: "interval", value: days.interval),
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
                let marketChart = try decoder.decode(MarketChart.self, from: data)
                completion(.success(marketChart))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        
        task.resume()
    }
}
