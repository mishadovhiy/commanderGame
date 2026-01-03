//
//  AudioViewController.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 27.12.2025.
//

import UIKit
import AVFAudio

class AudioViewController: BaseViewController {
        
    private var audioPlayers: [AVAudioPlayer] = []
    var audioFiles: [AudioFileNameType] {[]}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayers = audioFiles.compactMap({
            let player = try? AVAudioPlayer(contentsOf: Bundle.main.url(forResource: $0.rawValue, withExtension: $0.format.rawValue)!)
            player?.volume = $0.volume
            if $0.rawValue.lowercased().contains("loop") {
                player?.numberOfLoops = -1
            }
            return player
        })
        setVoluem()
    }
    
    override func soundDidChange() {
        super.soundDidChange()
        setVoluem()
    }
    
    func setVoluem() {
        DispatchQueue(label: "sound", qos: .background).async {
            let db = DataBaseService.db.settings.sound.voluem
            let dict = try? db.dictionary() ?? [:]
            DispatchQueue.main.async {
                type(of: db).CodingKeys.allCases.forEach { key in
                    let value = dict?[key.rawValue] as? CGFloat ?? 0
                    self.setSoundEnabled(value != 0, type: key)
                }
            }
        }
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: {
            self.audioPlayers.removeAll()
            completion?()
        })
        
    }
    
    deinit {
        self.audioPlayers.removeAll()
    }
    
    func play(_ name: AudioFileNameType) {
        guard let player = self.audioPlayers.first(where: {
            $0.url?.lastPathComponent.contains(name.rawValue) ?? false
        }) else {
            print("audio file names ", name.rawValue, " has not been initialised")
            return
        }
        if player.volume == 0 {
            return
        }
        player.prepareToPlay()
        player.play()
    }
    
    func setSoundEnabled(_ isEnubled: Bool, type: AudioFileNameType.SoundType) {
        audioPlayers.forEach { player in
            let nameType = AudioFileNameType.allCases.first(where: {
                player.url?.lastPathComponent.contains($0.rawValue) ?? false
            })
            player.volume = isEnubled ? (nameType?.volume ?? 0) : 0
        }
    }
    
    func stop() {
        audioPlayers.forEach {
            $0.stop()
        }
    }
}

