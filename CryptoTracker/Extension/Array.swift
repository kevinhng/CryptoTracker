//
//  Array.swift
//  CryptoTracker
//
//  Created by Kevin Hoàng on 04.03.22.
//

import Foundation

extension Array where Element == Double {
    
    /// Normalize all elements of an Array
    /// ```
    /// [1,2,3,4,5] -> [0.0, 0.25, 0.5, 0.75, 1.0]
    /// ```
    var normalized: [Double] {
        if let min = self.min(), let max = self.max() {
            return self.map { ($0 - min) / (max - min) }
        }
        return []
    }
}
