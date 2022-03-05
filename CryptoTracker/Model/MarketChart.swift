//
//  MarketChart.swift
//  CryptoTracker
//
//  Created by Kevin Hoàng on 04.03.22.
//

import Foundation

// https://api.coingecko.com/api/v3/coins/ethereum/market_chart?vs_currency=usd&days=30&interval=daily

struct MarketChart: Codable {
    let chart: [[Double]]
    
    var timestamps: [Double] {
        return chart.map { return $0[0] }
    }
    
    var prices: [Double] {
        return chart.map { return $0[1] }
    }
}
