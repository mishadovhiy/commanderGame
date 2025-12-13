//
//  GameViewController.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 11.12.2025.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    @IBOutlet private weak var upgradeWeaponButton: UIButton!
    @IBOutlet private weak var weaponsStackView: UIStackView!
    @IBOutlet private weak var editingWeaponImageView: UIImageView!
    @IBOutlet private weak var weaponTableView: UITableView!
    
    private var weaponTableData: [WeaponTableData] = []
    private var weaponHolder: CGPoint?

    override func loadView() {
        super.loadView()
        loadUI()
    }
    
    private var gameScene: GameScene? {
        (view as? SKView)?.scene as? GameScene
    }
    
    private var editingWeapon: WeaponNode? {
        gameScene?.weapons.first(where: {
            $0.isEditing
        })
    }
    
    private func setWeaponTableData() {
        weaponTableData = [
            .init(icon: nil, title: "name", text: nil),
            .init(icon: nil, title: "dif", text: editingWeapon?.upgrade?.rawValue ?? ""),
            .init(icon: nil, title: nil, text: "some long text in a multiple lines to test ui")

        ]
        weaponTableView.reloadData()
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
    
    @IBAction private func hideEditingPressed(_ sender: Any) {
        editingWeapon?.isEditing = false
        didSetEditingWeaponNode()
    }
    
    @IBAction private func upgradeWeaponPressed(_ sender: Any) {
        print((editingWeapon?.upgrade?.index ?? -1) + 1, " yh5rtegfd")
        editingWeapon?.upgrade = .allCases[(editingWeapon?.upgrade?.index ?? -1) + 1]
    }

    @IBAction private func deleteWeaponPressed(_ sender: Any) {
        editingWeapon?.removeFromParent()
        didSetEditingWeaponNode()
    }
    
    public func didSetEditingWeaponNode() {
        self.view.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, animations: {
            self.editingWeaponImageView.superview?.isHidden = self.editingWeapon == nil
            if let type = self.editingWeapon?.type {
                self.editingWeaponImageView.image = .init(named: type.rawValue)
                let canUpgrade = self.editingWeapon?.canUpgrade ?? true
                self.upgradeWeaponButton.isEnabled = canUpgrade
                let title = canUpgrade ? "Upgrade\n\(self.editingWeapon?.upgradePrice ?? 0)" : "Max"
                self.upgradeWeaponButton.setTitle(title, for: .normal)
                self.upgradeWeaponButton.setTitle(title, for: .disabled)
                self.setWeaponTableData()

            }
        }, completion: { _ in
            self.view.isUserInteractionEnabled = true
            if self.editingWeapon?.type == nil {
                self.editingWeaponImageView.image = nil
                self.upgradeWeaponButton.setTitle("Upgrade", for: .normal)
                self.upgradeWeaponButton.setTitle("Upgrade", for: .disabled)

            }
        })
    }
}

fileprivate
extension GameViewController {
    func loadUI() {
        loadScene()
        loadWeapons()
        weaponTableView.delegate = self
        weaponTableView.dataSource = self
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

extension GameViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weaponTableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: .init(describing: WeaponDescriptionCell.self), for: indexPath) as? WeaponDescriptionCell {
            cell.set(weaponTableData[indexPath.row])
            return cell
        }
        return .init()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

extension GameViewController {
    struct WeaponTableData {
        let icon: String?
        let title: String?
        let text: String?
    }
}
