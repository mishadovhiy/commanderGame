//
//  AudioFileNameType.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 27.12.2025.
//

import Foundation

enum AudioFileNameType: String {
    case explosure1
    
    typealias SoundType = DataBaseModel.Settings.Sound.Voluem.CodingKeys
    
    var type: SoundType {
        switch self {
        case .explosure1:
                .gameSound
        }
    }
    
    enum Format: String {
        case m4a
    }
    
    var format: Format {
        switch self {
        case .explosure1:
                .m4a
        }
    }
}
