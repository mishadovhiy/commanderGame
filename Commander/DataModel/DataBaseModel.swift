//
//  DataBaseModel.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 14.12.2025.
//

import Foundation

struct DataBaseModel: Codable {
    private var _upgradedWeaponsss: [WeaponType: [WeaponUpgradeType: Int]]? = [:]
    
    var upgradedWeapons: [WeaponType: [WeaponUpgradeType: Int]] {
        get {
            _upgradedWeaponsss ?? [:]
        }
        set {
            _upgradedWeaponsss = newValue
        }
    }
    var completedLevels: [LevelModel: GameProgress] = [:]
    
    private var _progress: [LevelModel: UncomplitedProgress]? = [:]
    var progress: [LevelModel: UncomplitedProgress] {
        get {
            _progress ?? [:]
        }
        set {
            _progress = newValue
        }
    }
    
    var settings: Settings = .init()
}

extension DataBaseModel {
    struct Settings: Codable {
        var sound: Sound = .init()
        
        struct Sound: Codable {
            var voluem: Voluem = .init()
            
            nonisolated
            struct Voluem: Codable {
                var gameSound: CGFloat = 0.2
                var music: CGFloat = 0.2
                var menu: CGFloat = 0.2
                
                
                enum CodingKeys: String, CaseIterable, CodingKey {
                    case gameSound
                    case music
                    case menu
                }
            }
        }
    }
}
