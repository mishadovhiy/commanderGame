//
//  GameViewController.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 11.12.2025.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            let scene = GameScene.configure(lvl: .init(.test))
            scene.scaleMode = .aspectFill

            view.presentScene(scene, transition: .doorsCloseHorizontal(withDuration: 0.6))
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

}
