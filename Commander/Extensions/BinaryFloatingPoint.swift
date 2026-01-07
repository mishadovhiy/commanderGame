//
//  BinaryFloatingPoint.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 07.01.2026.
//

import Foundation

extension BinaryFloatingPoint {
    var closesPercent: Self {
        let n = self * 100
        let int = [25, 50, 75, 100].min(by: {
            return abs($0 - Int(n)) < abs($1 -  Int(n))
        })
        return Self(int ?? 0) / 100
    }
}
