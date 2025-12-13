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
    private var weaponHolder: CGPoint?
    
    override func loadView() {
        super.loadView()
        loadUI()
    }
    
    private var gameScene: GameScene? {
        (view as? SKView)?.scene as? GameScene
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
        switch sender.state {
        case .cancelled, .ended, .failed:
            didEndDragging(view: view)
        case .began:
            weaponHolder = view.center
        default: break
        }
        view.frame.origin = CGPoint(
            x: view.frame.origin.x + translation.x,
            y: view.frame.origin.y + translation.y
        )
        sender.setTranslation(.zero, in: view.superview)
        
    }
    
    private func didEndDragging(view: UIView) {
        view.isUserInteractionEnabled = false
        
        var position = view.positionInSuperview(s: self.view)
        position.x += view.frame.size.width / 2
        position.y += view.frame.size.height / 2
        let verticalSafeArea = self.view.safeAreaInsets.top + self.view.safeAreaInsets.bottom
        let hosrizontalSafeArea = self.view.safeAreaInsets.left + self.view.safeAreaInsets.right
        let superViewSize: CGSize = .init(
            width: self.view.frame.width + hosrizontalSafeArea,
            height: self.view.frame.height + verticalSafeArea)
        let percent = CGPoint(
            x: (position.x + (hosrizontalSafeArea / 2)) / superViewSize.width,
            y: (self.view.frame.height - position.y) / superViewSize.height)
        print(percent, " ghjbnkmnjbh ", position.x)
        gameScene?.loadArmour(position: percent)
        UIView.animate(withDuration: 0.3, delay: 0, animations: {
            view.center = self.weaponHolder ?? .zero
        }, completion: { _ in
            view.isUserInteractionEnabled = true
            self.weaponHolder = nil
        })
    }
    
    public func didSetEditingWeaponNode() {
        guard let editingNode = gameScene?.weapons.first(where: {
            $0.isEditing
        }) else {
            return
        }
        
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

extension UIView {
    func positionInSuperview(_ position: CGPoint = .zero, s: UIView) -> CGPoint {
        var position = position
        position.x += frame.minX
        position.y += frame.minY
        print(position, " positionpositionposition")
        if self.superview == s {
            return position
        } else {
            return self.superview?.positionInSuperview(position, s: s) ?? position
        }
    }
}
