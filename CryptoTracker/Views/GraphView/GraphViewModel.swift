//
//  GraphViewModel.swift
//  CryptoTracker
//
//  Created by Kevin Hoàng on 04.03.22.
//

import Foundation

class GraphViewModel {
    
    var coin: Coin
    var chart: MarketChart? {
        didSet {
            self.delegate?.didLoad()
        }
    }
    
    weak var delegate: GraphViewModelDelegate?
    
    init(coin: Coin, for days: ChartDays) {
        self.coin = coin
        
        getMarketChart(days: days)
    }
    
    private func getMarketChart(days: ChartDays) {
        MarketChartService.shared.getMarketData(for: self.coin, days: days) { [weak self] completion in
            switch completion {
            case .success(let marketChart):
                self?.chart = marketChart
            case .failure(let error):
                print(error)
            }
        }
    }
}

protocol GraphViewModelDelegate: NSObject {
    func didLoad()
}
