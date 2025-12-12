//
//  GameViewController.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 11.12.2025.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    @IBOutlet private weak var weaponsStackView: UIStackView!
    
    override func loadView() {
        super.loadView()
        loadUI()
    }
    
    @IBAction private func speedPressed(_ sender: UIButton) {
    }
    
    @IBAction private func menuPressed(_ sender: Any) {
    }
    
    @IBAction private func playPausePressed(_ sender: UIButton) {
    }
    
    @IBAction private func hideButtonsPressed(_ sender: UIButton) {
        let icon = sender.tag == 1 ? "arrowshape.right.fill" : "arrowshape.left.fill"
        sender.tag = sender.tag == 1 ? 0 : 1
        UIView.animate(withDuration: 0.3, delay: 0, options: [.transitionFlipFromRight, .allowUserInteraction]) {
            if #available(iOS 13.0, *) {
                sender.setImage(.init(systemName: icon), for: .normal)
            }
            self.weaponsStackView.isHidden = !self.weaponsStackView.isHidden
        }
    }
    
    @objc private func weaponDragging(_ sender: UIPanGestureRecognizer) {
        guard let view = sender.view else { return }
        let translation = sender.translation(in: self.view)
        view.center = CGPoint(
                x: view.center.x + translation.x,
                y: view.center.y + translation.y
            )
        sender.setTranslation(.zero, in: view.superview)
    }
}

fileprivate
extension GameViewController {
    func loadUI() {
        loadScene()
        loadWeapons()
    }
    
    func loadScene() {
        if let view = view as! SKView? {
            let scene = GameScene.configure(lvl: .init(.test))
            scene.scaleMode = .aspectFill
            
            view.presentScene(scene, transition: .doorsCloseHorizontal(withDuration: 0.6))
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    func loadWeapons() {
        WeaponType.allCases.forEach {
            let image = UIImageView(image: .init(named: $0.rawValue))
            image.contentMode = .scaleAspectFit
            image.translatesAutoresizingMaskIntoConstraints = false
            image.heightAnchor.constraint(equalToConstant: 30).isActive = true
            image.widthAnchor.constraint(equalToConstant: 30).isActive = true
            weaponsStackView.addArrangedSubview(image)
            image.isUserInteractionEnabled = true
            image.addGestureRecognizer(UIPanGestureRecognizer(
                target: self,
                action: #selector(weaponDragging(_:))
            ))
        }
    }
}

