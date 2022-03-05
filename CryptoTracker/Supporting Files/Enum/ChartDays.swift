//
//  ChartDays.swift
//  CryptoTracker
//
//  Created by Kevin Hoàng on 05.03.22.
//

import Foundation

enum ChartDays: String, CaseIterable {
    case one = "24h"
    case seven = "7d"
    case thirty = "30d"
    case ninety = "90d"
    case year = "1y"
    case max = "Max"
    
    var urlValue: String {
        switch self {
        case .one:
            return "1"
        case .seven:
            return "7"
        case .thirty:
            return "30"
        case .ninety:
            return "90"
        case .year:
            return "365"
        case .max:
            return "max"
        }
    }
}
