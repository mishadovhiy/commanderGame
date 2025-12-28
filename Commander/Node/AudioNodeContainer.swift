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
    
    override func removeFromParent() {
        self.children.forEach {
            $0.removeFromParent()
        }
        self.removeAllActions()
        self.removeAllChildren()
        
        super.removeFromParent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateVolume(canPlay: Bool) {
        audioNodes.forEach { node in
            let volume = (AudioFileNameType.init(rawValue: node.name ?? "") ?? .coins).volume
            node.avAudioNode?.engine?.mainMixerNode.outputVolume = canPlay ? volume : .zero
            node.run(.changeVolume(to: canPlay ? volume : 0, duration: 0))
        }
    }
    
    func play(_ file: AudioFileNameType) {
        guard let audioNode = audioNodes.first(where: {
            $0.name == file.rawValue
        }) else {
            print("AudioFileNameType named: ", file.rawValue, " has not been added into initializer")
            return
        }
        
        if audioNode.avAudioNode?.engine?.mainMixerNode.outputVolume == .zero || audioNode.hasActions() {
            return
        }
        audioNode.run(.play())
        
    }
}
