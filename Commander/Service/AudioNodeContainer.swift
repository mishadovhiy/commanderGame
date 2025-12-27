//
//  AudioNodeContainer.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 27.12.2025.
//

import SpriteKit
import AVFoundation

class AudioContainerNode: SKNode {
    
    private let audioNodes: [SKAudioNode]

    init(audioNames: [AudioFileNameType]) {
        audioNodes = audioNames.compactMap({
            let node = SKAudioNode(fileNamed: $0.rawValue + "." + $0.format.rawValue)
            node.autoplayLooped = false
            node.name = $0.rawValue
            return node
        })
        super.init()
        self.volumeChanged(0.5, for: .gameSound)
        audioNodes.forEach {
            self.addChild($0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func volumeChanged(_ newVolume: Float, for type: AudioFileNameType.SoundType) {
        audioNodes.forEach { node in
            node.avAudioNode?.engine?.mainMixerNode.volume = newVolume
            node.avAudioNode?.engine?.mainMixerNode.outputVolume = newVolume

        }
    }
    
    func play(_ file: AudioFileNameType) {
        guard let audioNode = audioNodes.first(where: {
            $0.name == file.rawValue
        }) else {
            print("AudioFileNameType named: ", file.rawValue, " has not been added into initializer")
            return
        }
        audioNode.run(.play())
        
    }
}
