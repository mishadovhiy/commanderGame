//
//  AudioFileNameType.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 27.12.2025.
//

import Foundation

enum AudioFileNameType: String, CaseIterable {
    case explosure1, explosure, explosure3, explosure4
    case shoot1, shoot2, hit1, hit2
    case menu1, menu2, menu3
    case weaponUpgrade, success1, success2, coins
    
    typealias SoundType = DataBaseModel.Settings.Sound.Voluem.CodingKeys
    
    var type: SoundType {
        switch self {
        case .menu1, .menu2, .menu3, .weaponUpgrade,
                .success1, .success2, .coins:
                .menu
        default:
                .gameSound
        }
    }
    
    var volume: Float {
        switch self.type {
        case .menu:
            0.1
        case .music:
            0.2
        case .gameSound:
            0.3
        }
    }
    
    enum Format: String {
        case m4a
    }
    
    var format: Format {
        switch self {
        default:
                .m4a
        }
    }
}
