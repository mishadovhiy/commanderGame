//
//  Difficulty.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 11.12.2025.
//

import Foundation

enum Difficulty: String, CaseIterable {
    case easy, normal, hard
    
    var index: Int {
        (Self.allCases.firstIndex(of: self) ?? 0)
    }
}

