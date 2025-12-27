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
        //set from db
        audioNodes.forEach {
            self.addChild($0)
        }
        self.updateVolume(canPlay: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateVolume(canPlay: Bool) {
        audioNodes.forEach { node in
            let volume = (AudioFileNameType.init(rawValue: node.name ?? "") ?? .coins).volume
            node.avAudioNode?.engine?.mainMixerNode.outputVolume = canPlay ? volume : 0

        }
    }
    
    func play(_ file: AudioFileNameType) {
        guard let audioNode = audioNodes.first(where: {
            $0.name == file.rawValue
        }) else {
            print("AudioFileNameType named: ", file.rawValue, " has not been added into initializer")
            return
        }
        if audioNode.avAudioNode?.engine?.mainMixerNode.volume == 0 {
            return
        }
        audioNode.run(.play())
        
    }
}
