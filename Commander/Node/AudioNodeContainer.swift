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
    private var durations: [AudioFileNameType: Double] = [:]
    
    init(audioNames: [AudioFileNameType], canPlaySound: Bool) {
        var durations: [AudioFileNameType: Double] = [:]
        audioNodes = audioNames.compactMap({
            if let url = Bundle.main.url(
                forResource: $0.rawValue,
                withExtension: $0.format.rawValue) {
                let audio = AVURLAsset(url: url)
                durations.updateValue(audio.duration.seconds, forKey: $0)
            }
           
            let node = SKAudioNode(fileNamed: $0.rawValue + "." + $0.format.rawValue)
            node.autoplayLooped = false
            node.name = $0.rawValue
            node.isPositional = true
            return node
        })
        self.durations = durations
        super.init()
        audioNodes.forEach {
            self.addChild($0)
        }
        updateVolume(canPlay: canPlaySound)
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
        print(canPlay, " gfeedwdsc ")
        audioNodes.forEach { node in
            let volume = (AudioFileNameType.init(rawValue: node.name ?? "") ?? .coins).volume
            node.avAudioNode?.engine?.mainMixerNode.outputVolume = canPlay ? volume : .zero
            node.avAudioNode?.engine?.mainMixerNode.volume = canPlay ? volume : .zero
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

        audioNode.run(.sequence([
            .play(),
            .wait(forDuration: self.durations[file] ?? 0),
            .stop()
        ]))
    }
}
