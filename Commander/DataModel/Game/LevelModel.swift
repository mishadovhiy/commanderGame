//
//  LevelModel.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 11.12.2025.
//

import Foundation

nonisolated
struct LevelModel: Codable, Hashable, Equatable {
    let level: String
    var levelPage: String?
    var difficulty: Difficulty?
    var duration: GameDurationType?
    
    var hasEmptyValue: Bool {
        let dict = try? dictionary()
        return !(dict?.count ?? 0 >= 3)
    }
    
}

extension LevelModel {
    static var test: Self {
        .init(level: "0", difficulty: .easy, duration: .normal)
    }
}
