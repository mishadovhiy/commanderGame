//
//  LevelModel.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 11.12.2025.
//

import Foundation

nonisolated
struct LevelModel: Codable, Hashable, Equatable {
    var level: String = ""
    var levelPage: String = "1"
    var difficulty: Difficulty?
    var duration: GameDurationType?
    
    var hasEmptyValue: Bool {
        let dict = try? dictionary()
        return !(dict?.count ?? 0 >= 4)
    }    
}

extension [LevelModel] {
    var topCompletedLevel: Self.Element? {
        self.sorted(by: {
            Int($0.level) ?? 0 >= Int($1.level) ?? 0
        }).first
    }
    
    var completedPages: [Int] {
        let pages = [LevelPagesBuilder].allData
        var dict: [String: Int] = [:]
        self.forEach { level in
            dict.updateValue((dict[level.levelPage] ?? 0) + 1, forKey: level.levelPage)
        }
        return dict.filter({ level in
            let c = pages.first(where: {$0.title == level.key})
            return c?.levels.count ?? 0 <= level.value
        }).compactMap({
            Int($0.key) ?? 0
        })
    }
}

extension LevelModel {
    static var test: Self {
        .init(level: "0", difficulty: .easy, duration: .normal)
    }
}
