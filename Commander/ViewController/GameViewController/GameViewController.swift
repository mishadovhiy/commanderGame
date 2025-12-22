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
    
    private var weaponTableData: [TableDataModel] = []
    private var weaponHolder: CGPoint?
    var selectedLevel: LevelModel!
    
    override func loadView() {
        super.loadView()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        loadScene()
        loadWeapons()
        weaponTableView.register(.init(nibName: .init(describing: TableDataCell.self), bundle: nil), forCellReuseIdentifier: .init(describing: TableDataCell.self))
        weaponTableView.delegate = self
        weaponTableView.dataSource = self
        didSetEditingWeaponNode()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        gameScene?.removeAllActions()
        gameScene?.removeAllChildren()
        gameScene?.removeFromParent()
        view.removeFromSuperview()
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
        if sender.tag == 2 {
            sender.tag = 0
        } else {
            sender.tag += 1
        }
        gameScene?.speed = 1 + CGFloat(sender.tag)
        switch sender.tag {
        case 1:
            sender.setImage(.speed2, for: .init())
            sender.tintColor = .dark
        case 2:
            sender.setImage(.speed, for: .init())
            sender.tintColor = .dark
        default:
            sender.setImage(.speed, for: .init())
            sender.tintColor = .dark.withAlphaComponent(0.35)
        }
    }
    
    @IBAction private func menuPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction private func playPausePressed(_ sender: UIButton) {
        gameScene?.isPaused.toggle()
        sender.setImage((gameScene?.isPaused ?? false) ? .play : .pause, for: .init())
    }
    
    @IBAction private func hideButtonsPressed(_ sender: UIButton) {
        let icon = sender.tag == 1 ? "arrowshape.right.fill" : "arrowshape.left.fill"
        sender.tag = sender.tag == 1 ? 0 : 1
        UIView.animate(withDuration: 0.3, delay: 0, options: [.transitionFlipFromRight, .allowUserInteraction]) {
            if #available(iOS 13.0, *) {
                sender.setImage(.init(systemName: icon), for: .init())
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
            view.subviews.first?.removeFromSuperview()
        case .began:
            weaponHolder = view.center
            view.addSubview(.init())
            view.layer.masksToBounds = false
            if let back = view.subviews.first {
                back.translatesAutoresizingMaskIntoConstraints = false
                back.layer.zPosition = -1
                NSLayoutConstraint.activate([
                    back.leadingAnchor.constraint(equalTo: back.superview!.leadingAnchor, constant: -20),
                    back.trailingAnchor.constraint(equalTo: back.superview!.trailingAnchor, constant: 20),
                    back.topAnchor.constraint(equalTo: back.superview!.topAnchor, constant: -20),
                    back.bottomAnchor.constraint(equalTo: back.superview!.bottomAnchor, constant: 20)
                ])
            }
        default: break
        }
        view.frame.origin.x += translation.x
        view.frame.origin.y += translation.y
        view.subviews.first?.backgroundColor = (gameScene?.canPlace(
            at: positionPercent(view)) ?? false) ? .green : .red
        sender.setTranslation(.zero, in: view.superview)
        
    }
    
    func positionPercent(_ view: UIView) -> CGPoint {
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
        return percent
    }
    
    private func didEndDragging(view: UIView) {
        view.isUserInteractionEnabled = false
        let percent = positionPercent(view)
        if gameScene?.canPlace(at: percent) ?? false {
            gameScene?.loadArmour(type: .init(rawValue: view.layer.name ?? "") ?? .basuka, position: percent)
        }
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
        editingWeapon?.isEditing = false
        didSetEditingWeaponNode()
    }

    @IBAction private func deleteWeaponPressed(_ sender: Any) {
        editingWeapon?.removeFromParent()
        didSetEditingWeaponNode()
    }
    
    public func didSetEditingWeaponNode() {
        self.view.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, animations: {
            self.editingWeaponImageView.superview?.superview?.isHidden = self.editingWeapon == nil
            if let type = self.editingWeapon?.type {
                self.editingWeaponImageView.image = .init(named: type.rawValue)
                let canUpgrade = self.editingWeapon?.canUpgrade ?? true
                self.upgradeWeaponButton.isEnabled = canUpgrade
                let title = canUpgrade ? "Upgrade\n\(self.editingWeapon?.upgradePrice ?? 0)" : "Max"
                self.upgradeWeaponButton.setTitle(title, for: .init())
                self.setWeaponTableData()

            }
        }, completion: { _ in
            self.view.isUserInteractionEnabled = true
            if self.editingWeapon?.type == nil {
                self.editingWeaponImageView.image = nil
                self.upgradeWeaponButton.setTitle("Upgrade", for: .init())

            }
        })
    }
}

fileprivate
extension GameViewController {
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
            image.layer.name = $0.rawValue
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: .init(describing: TableDataCell.self), for: indexPath) as? TableDataCell {
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
    static func initiate(_ level: LevelModel) -> Self {
        let vc = Self.initiateDefault()
        vc.selectedLevel = level
        return vc
    }
}
