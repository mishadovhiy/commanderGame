//
//  GameViewController.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 11.12.2025.
//

import SpriteKit

class GameViewController: AudioViewController {
    
    @IBOutlet weak var enemyCountLabel: UILabel!
    @IBOutlet weak var loadingRoundStackView: UIStackView!
    @IBOutlet weak var loadingRoundTitle: UILabel!
    @IBOutlet weak var healthLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet private weak var upgradeWeaponButton: UIButton!
    @IBOutlet private weak var weaponsStackView: UIStackView!
    @IBOutlet private weak var editingWeaponImageView: UIImageView!
    @IBOutlet private weak var weaponTableView: UITableView!
    
    private var weaponTableData: [TableDataModel] = []
    private var weaponHolder: CGPoint?
    var selectedLevel: LevelModel!
    var page: LevelPagesBuilder!
    override var audioFiles: [AudioFileNameType] {
        AudioFileNameType.allCases
    }
    var gameBackgroundColor: UIColor {
        LevelManager(selectedLevel).lvlBuilder.appearence.backgroundColor ?? page.appearence.backgroundColor!
    }
    
    override func loadView() {
        super.loadView()
        self.loadingRoundStackView.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.setupLabels()
        weaponTableView.register(.init(nibName: .init(describing: TableDataCell.self), bundle: nil), forCellReuseIdentifier: .init(describing: TableDataCell.self))
        weaponTableView.delegate = self
        weaponTableView.dataSource = self
        didSetEditingWeaponNode()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue(label: "db", qos: .background).async {
            let db = DataBaseService.db
            let cloud = IcloudService().loadDataBaseCopy
            DispatchQueue.main.async {
                self.loadWeapons(db: cloud)
                self.loadScene(db: cloud, localDB: db)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        saveProgress {
            self.gameScene?.removeAllActions()
            self.gameScene?.removeAllChildren()
            self.gameScene?.removeFromParent()
            self.view.removeFromSuperview()
        }
        super.viewDidDisappear(animated)
    }
    
    func saveProgress(completed:@escaping()->() = {}) {
        let size = view.frame.size

        guard let scene = gameScene,
              let lvl = gameScene?.lvlanager.lvlModel,
              let progress = gameScene?.lvlanager.progress
        else {
            return
        }
        let result: UncomplitedProgress = .init(
            gameProgress: progress,
            weapons: Dictionary(uniqueKeysWithValues: gameScene!.weapons.map({
                let x = (($0.position.x + (size.width / 2)) / size.width)
                let y = (($0.position.y + (size.height / 2)) / size.height)
                return ($0.type.rawValue + ($0.name ?? ""), CGPoint(x: x, y: y))
            })),
            weaponUpdates: Dictionary(uniqueKeysWithValues: gameScene!.weapons.map({
                ($0.type.rawValue + ($0.name ?? ""), $0.upgrade)
            })))
        DispatchQueue(label: "db", qos: .userInitiated).async {
            var service = IcloudService()
            service.loadDataBaseCopy.progress.updateValue(result, forKey: lvl)
            DispatchQueue.main.async {
                completed()
            }
        }
    }
    
    func applicationWillResignActive() {        
        saveProgress()
    }
    
    override func soundDidChange() {
        super.soundDidChange()
        gameScene?.soundDidChange()
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
            .init(icon: nil, title: editingWeapon?.type.rawValue, text: "Price: $\(editingWeapon?.upgradePrice ?? 0)"),
            .init(icon: nil, title: "Upgrade", text: """
                Level: \(editingWeapon?.upgrade?.rawValue ?? "-")
                Damage: \(editingWeapon?.damage ?? 0)
                Distance: \(editingWeapon?.distance ?? 0)
                """)

        ]
        weaponTableView.reloadData()
    }
    
    func progressUpdated(lvlManager: LevelManager) {
        if lvlManager.lvlModel.duration == .infinityRounds {
            roundLabel.text = "\(lvlManager.progress.currentRound + lvlManager.progress.roundRepeated)"
        } else {
            roundLabel.text = "\(lvlManager.progress.currentRound)/\(lvlManager.lvlBuilder.rounds)"
        }
        healthLabel.text = "\(lvlManager.progress.health)"
        
        balanceLabel.text = "\(lvlManager.progress.moneyResult)"
        self.enemyCountLabel.text = "\(lvlManager.progress.passedEnemyCount)/\(lvlManager.progress.killedEnemies)"
        UIView.animate(withDuration: 0.16) {
            self.updateWeaponsEnabled()
        }
    }
    
    @IBAction private func speedPressed(_ sender: UIButton) {
        play(.menu1)
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
        play(.menu1)
        gameScene?.isPaused = true
let vc = AlertViewController.initiate(data: .init(title: "Menu", type: .collectionView([
    AlertModel.LevelProgressModel(title: "s", level: self.selectedLevel),
    AlertModel.TitleCellModel(button: .init(title: "Sound", toAlert: {
.init(title: "Sound", type: .soundSettingsData, buttons: [])
})),
    AlertModel.TitleCellModel(button: .init(title: "Exit game", didPress: { [weak self] in
        guard let self else { return }
        let vc = self.presentedViewController ?? self
        vc.dismiss(animated: true) {
            self.dismiss(animated: true)
        }
    })),
    AlertModel.TitleCellModel(button: .init(title: "Delete Progress and quit", toAlert: {
        .init(title: "Are you suze", type: .collectionView([
            AlertModel.TitleCellModel.init(title: "no"),
            AlertModel.TitleCellModel.init(button: .init(title: "yes", didPress: {
                let vc = self.presentedViewController ?? self
                let lvl = self.selectedLevel
                vc.dismiss(animated: true) {
                    self.dismiss(animated: true) {
                        guard let lvl else {
                            return
                        }
                        DispatchQueue(label: "db", qos: .background).async {
                            var dbModel = IcloudService()
                            dbModel.loadDataBaseCopy.progress.removeValue(forKey: lvl)
                        }
                    }
                }
                
            }))
        ]), buttons: [])
    }))
]), buttons: []))
        vc.didDismiss = { [weak self] in
            self?.gameScene?.isPaused = false
        }
        self.present(vc: vc)
    }
    
    @IBAction private func playPausePressed(_ sender: UIButton) {
        play(.menu1)

        gameScene?.isPaused.toggle()
        sender.setImage((gameScene?.isPaused ?? false) ? .play : .pause, for: .init())
    }
    
    @IBAction private func hideButtonsPressed(_ sender: UIButton) {
        play(.menu2)
        let icon = sender.tag == 1 ? "arrowshape.right.fill" : "arrowshape.left.fill"
        sender.tag = sender.tag == 1 ? 0 : 1
        UIView.animate(withDuration: 0.3, delay: 0, options: [.transitionFlipFromRight, .allowUserInteraction]) {
            if #available(iOS 13.0, *) {
                sender.setImage(.init(systemName: icon), for: .init())
            }
            self.weaponsStackView.isHidden = !self.weaponsStackView.isHidden
            self.view.subviews.forEach {
                if $0.tag != 1, let stack = $0 as? UIStackView {
                    stack.arrangedSubviews.forEach {
                        if $0 is UIButton {
                            $0.isHidden = self.weaponsStackView.isHidden

                        }
                    }
                }
            }
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
            at: positionPercent(view)) ?? false) ? .clear : .red
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
            let weapon = WeaponType(rawValue: view.layer.name ?? "")
            gameScene?.lvlanager.progress.earnedMoney -= ((weapon?.upgradeStepPrice ?? 0) * Int((gameScene?.lvlanager.progress.pageDivider ?? 0) * 1350))

            gameScene?.loadArmour(type: .init(rawValue: view.layer.name ?? "") ?? .basuka, position: percent)
        }
        setInitialDraggingPosition(view: view)
    }
    
    func setInitialDraggingPosition(view: UIView) {
        UIView.animate(withDuration: 0.3, delay: 0, animations: {
            view.center = self.weaponHolder ?? .zero
        }, completion: { _ in
            view.isUserInteractionEnabled = true
            self.weaponHolder = nil
        })
    }
    
    @IBAction private func hideEditingPressed(_ sender: Any) {
        play(.menu1)
        editingWeapon?.isEditing = false
        didSetEditingWeaponNode()
    }
    
    @IBAction private func upgradeWeaponPressed(_ sender: Any) {
        play(.coins)
        let price = editingWeapon?.upgradePrice ?? 0
        if gameScene?.lvlanager.progress.moneyResult ?? 0 >= price  {
            gameScene?.lvlanager.progress.earnedMoney -= (price * Int((gameScene?.lvlanager.progress.pageDivider ?? 0) * 1350))
            editingWeapon?.upgrade = .allCases[(editingWeapon?.upgrade?.index ?? -1) + 1]
            editingWeapon?.isEditing = false
            didSetEditingWeaponNode()
        }
    }

    @IBAction private func deleteWeaponPressed(_ sender: Any) {
        play(.menu3)
        let price = (Float(editingWeapon?.upgradePrice ?? 0) * (1350 * Float(gameScene?.lvlanager.progress.pageDivider ?? 0))) / 2
        gameScene?.lvlanager.progress.earnedMoney += Int(price)
        editingWeapon?.removeFromParent()
        didSetEditingWeaponNode()
    }
    
    public func didSetEditingWeaponNode() {
        play(.menu1)
        self.view.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.15, animations: {
            self.editingWeaponImageView.superview?.superview?.isHidden = self.editingWeapon == nil
            if let type = self.editingWeapon?.type {
                DispatchQueue(label: "db", qos: .userInitiated).async {
                    let updatedNumber = self.gameScene?.db.upgradedWeapons[type]?[.attackPower] ?? 0
                    //DataBaseService.db.upgradedWeapons[type]?[.attackPower] ?? 0
                    DispatchQueue.main.async {
                        self.editingWeaponImageView.image = .init(named: type.rawValue + "/\(type.upgradedIconComponent(db: updatedNumber))")
                        let canUpgrade = self.editingWeapon?.canUpgrade ?? true
                        self.upgradeWeaponButton.isEnabled = canUpgrade
                        let title = canUpgrade ? "Upgrade\n\(self.editingWeapon?.upgradePrice ?? 0)" : "Max"
                        self.upgradeWeaponButton.setTitle(title, for: .init())
                        self.setWeaponTableData()
                    }
                }

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
    func prepareView() {
        self.view.subviews.forEach {
            if let stack = $0 as? UIStackView {
                if stack.tag == 1 {
                    stack.addBlurView()
                } else {
                    stack.arrangedSubviews.forEach {
                        $0.addBlurView()
                    }
                }
            }
        }
    }
    
    func setupLabels() {
        let isLightBackground = self.gameBackgroundColor.isLight
//        self.view.subviews.forEach {
//            if $0.tag != 1, let stack = $0 as? UIStackView {
//                stack.arrangedSubviews.forEach {
//                    if $0 is UIButton {
        var array = (view.subviews.compactMap({
            ($0 as? UIStackView)?.arrangedSubviews ?? []
        }).flatMap({$0}))
        array.append(contentsOf: [healthLabel, balanceLabel, roundLabel])
        let textColor: UIColor = isLightBackground ? .dark : .white.withAlphaComponent(0.7)
        array.forEach {
            let labels = ($0.superview as? UIStackView)?.arrangedSubviews ?? []
            if labels.isEmpty {
                if let label = $0 as? UILabel {
                    label.textColor = textColor

                } else if let button = $0 as? UIButton {
                    button.tintColor = textColor
                }

            } else {
                labels.forEach({
                    if let label = $0 as? UILabel {
                        label.textColor = textColor

                    } else if let imageView = $0 as? UIImageView {
                        imageView.tintColor = textColor

                    } else if let button = $0 as? UIButton {
                        button.tintColor = textColor
                    }
                })
            }
        }
        let backgroundColor = (isLightBackground ? UIColor.dark : UIColor(hex: "A88934")).withAlphaComponent(0.15)
        array.forEach {
            if let label = $0 as? UILabel {
                label.superview?.superview?.backgroundColor = backgroundColor

            } else if let button = $0 as? UIButton {
                button.backgroundColor = backgroundColor
            }
        }
    }
    
    func loadScene(db: CloudDataBaseModel, localDB: DataBaseModel) {
        if let view = view as! SKView? {
            let scene = GameScene.configure(lvl: .init(self.selectedLevel), page: self.page, db: db, canPlaySound: localDB.settings.sound.voluem.gameSound != 0)
            scene.scaleMode = .aspectFill
            
            view.presentScene(scene, transition: .doorsCloseHorizontal(withDuration: 0.6))
            view.ignoresSiblingOrder = true
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }
    
    func updateWeaponsEnabled() {
        weaponsStackView.arrangedSubviews.forEach {
            let type = WeaponType(rawValue: $0.layer.name ?? "")
            let canBuy = (self.gameScene?.lvlanager.progress.moneyResult ?? 0) >= (type?.upgradeStepPrice ?? 0)
            $0.isUserInteractionEnabled = canBuy
            $0.alpha = canBuy ? 1 : 0.5
        }
    }
    
    func loadWeapons(db: CloudDataBaseModel) {
        WeaponType.allCases.forEach {
            let i = db.upgradedWeapons[$0]?[.attackPower] ?? 0
            let stack = UIStackView()
            stack.axis = .vertical
            let image = UIImageView(image: .init(named: $0.rawValue + "/\($0.upgradedIconComponent(db: i))"))
            image.layer.name = $0.rawValue
            image.contentMode = .scaleAspectFit
            image.translatesAutoresizingMaskIntoConstraints = false
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.layer.name = $0.rawValue
            stack.alpha = 0.5
            stack.isUserInteractionEnabled = false
            weaponsStackView.addArrangedSubview(stack)
            stack.addArrangedSubview(image)
            image.heightAnchor.constraint(equalToConstant: 25).isActive = true
            stack.widthAnchor.constraint(equalToConstant: 35).isActive = true

            image.isUserInteractionEnabled = true
            image.addGestureRecognizer(UIPanGestureRecognizer(
                target: self,
                action: #selector(weaponDragging(_:))
            ))
            let label = UILabel()
            stack.addArrangedSubview(label)
            label.text = "\($0.upgradeStepPrice)"
            label.textColor = .white
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 11, weight: .medium).customFont()
        }
        let backgroundView = UIView()
        weaponsStackView.superview?.insertSubview(backgroundView, at: 0)
        backgroundView.layer.cornerRadius = 10
        backgroundView.layer.masksToBounds = true
        backgroundView.layer.borderColor = UIColor.extraDark.cgColor
        backgroundView.layer.borderWidth = 1
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.leadingAnchor.constraint(equalTo: backgroundView.superview!.leadingAnchor, constant: -3).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: backgroundView.superview!.trailingAnchor, constant: 3).isActive = true
        backgroundView.topAnchor.constraint(equalTo: backgroundView.superview!.topAnchor, constant: -3).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: backgroundView.superview!.bottomAnchor, constant: 3).isActive = true
        backgroundView.backgroundColor = .dark.withAlphaComponent(0.4)
        backgroundView.addBlurView()
        
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
    static func initiate(_ level: LevelModel, page: LevelPagesBuilder) -> Self {
        let vc = Self.initiateDefault()
        vc.selectedLevel = level
        vc.page = page
        return vc
    }
}
