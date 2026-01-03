//
//  GameScene.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 11.12.2025.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var page: LevelPagesBuilder!
    var canPlaySound: Bool!

    var lvlanager: LevelManager! {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                gameVC?.progressUpdated(lvlManager: lvlanager)
            }
        }
    }
    var currentRoundCount: Int = 0
    private var canLoadRound = true
    var loadingRound = false {
        didSet {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3) {
                    self.gameVC?.loadingRoundStackView.isHidden = !self.loadingRound
                }
                if self.loadingRound {
                    DispatchQueue.main.async {
                        self.gameVC?.loadingRoundTitle.text = "Loading round # \(self.lvlanager.progress.currentRound)\n(\(self.currentRoundCount))"
                    }
                }
            }
        }
    }
    private var levelCompleted = false
    private var gameVC: GameViewController? {
        view?.next as? GameViewController
    }

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        physicsWorld.contactDelegate = self
        loadSceneBackground()
        loadGraund()
        updateGraundPosition()
//        loadArmour(type: .granata, position: .init(x: 0.186, y: 0.22))
//        loadArmour(type: .pistol, position: .init(x: 0.271, y: 0.22))
        self.weapons.forEach({
            print($0.position, " tgerfwdas")
        })
        loadBlockers()
        self.loadRaund()
    }
        
    var enemyGround: SKShapeNode? {
        children.first(where: {
            $0.name == Constants.Names.enemyGround.rawValue
        }) as? SKShapeNode
    }
    
    var enemies: [EnemyNode] {
        self.children.filter({
            !(($0 as? EnemyNode)?.isRemoving ?? true)
        }).compactMap({
            $0 as? EnemyNode
        })
    }
    
    var enemiesForce: [EnemyNode] {
        self.children.filter({
            !(($0 as? EnemyNode)?.isRemovingForce ?? true)
        }).compactMap({
            $0 as? EnemyNode
        })
    }
    
    var weapons: [WeaponNode] {
        self.children.filter({
            $0 is WeaponNode
        }).compactMap({
            $0 as? WeaponNode
        })
    }
    
    func canPlace(at position: CGPoint) -> Bool {
        guard let viewSize = self.view?.frame.size else {
            fatalError()
        }
        let position: CGPoint = .init(
            x: (position.x * viewSize.width) - (viewSize.width / 2),
            y: (position.y * viewSize.height) - (viewSize.height / 2))
        
        if let first = self.weapons.first(where: { node in
            let x = ((node.position.x - node.size.width / 2)..<node.position.x + node.size.width / 2)
            let y = ((node.position.y - 60)..<node.position.y + 40)
            if x.contains(position.x) && y.contains(position.y) {
                return true
            }
            return false
        }) {
            print(first.name, " jjsbdjbdsj ")
            return false
        }
        
        let path = enemyGround?.path
        let strokedPath = path?.copy(
            strokingWithWidth: 65,
            lineCap: .round,
            lineJoin: .round,
            miterLimit: 10
        )
        if strokedPath?.contains(position) ?? true {
            return false
        }
        
        if self.children.contains(where: {
            $0.contains(position) && $0.name == "blockerNode"
        }) {
            print("blockerrr")
            return false
        }

        return true
    }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        weapons.forEach({
            $0.isEditing = false
        })
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        #warning("todo: weapon child pressed")
        var found = false
        weapons.forEach({
            let location = touch.location(in: $0)

            $0.children.forEach({
                if $0.name == "texture",
                   !found,
                   $0.contains(location),
                   let weapon = $0.parent as? WeaponNode
                {
                    weapon.isEditing.toggle()
                    gameVC?.didSetEditingWeaponNode()

                    found = true
                }
            })
        })
        if !found {
            gameVC?.didSetEditingWeaponNode()
        }
    }
    
    func loadArmour(type: WeaponType, position: CGPoint) {
        DispatchQueue(label: "db", qos: .userInitiated).async {
            let db = DataBaseService.db
            DispatchQueue.main.async {
                let node = WeaponNode(type: type, db: db, canPlaySound: self.canPlaySound)
                self.addChild(node)
                node.updatePosition(position: position)
            }
        }
        
    }

    func soundDidChange() {
        DispatchQueue(label: "sound", qos: .userInitiated).async {
            let canPlay = DataBaseService.db.settings.sound.voluem.gameSound
            self.canPlaySound = canPlay != 0
            DispatchQueue.main.async {
                self.children.forEach { node in
                    if let audio = node.children.first(where: {
                        $0 is AudioContainerNode
                    }) as? AudioContainerNode {
                        print(self.canPlaySound, " fdfsvfds ")
                        audio.updateVolume(canPlay: canPlay != 0)
                    }
                }
            }
        }
    }
    
    func saveScore() {
        let prize = Float(lvlanager.lvlBuilder.prize) * (Float(lvlanager.progress.score) / 100)
        let balance = Int(KeychainService.getToken(forKey: .balance) ?? "") ?? 0
        let _ = KeychainService.saveToken("\(balance + Int(prize))", forKey: .balance)
    }
    
    func didCompleteLevel() {
        if levelCompleted {
            return
        }
        levelCompleted = true
        let levelManager = self.lvlanager!
        DispatchQueue(label: "db", qos: .userInitiated).async {
            let oldProgress = DataBaseService.db.completedLevels[levelManager.lvlModel]
            if levelManager.progress.score >= oldProgress?.score ?? 0 {
                DataBaseService.db.completedLevels.updateValue(levelManager.progress, forKey: levelManager.lvlModel)
            }
            #warning("save new balance to keychain")
            print("game completed ", levelManager.lvlModel)
            self.saveScore()
            DispatchQueue.main.async {
                self.gameVC?.play(.success2)

                self.gameVC?.dismiss(animated: true) {
                    UIApplication.shared.activeWindow?.rootViewController?.present(vc: AlertViewController.initiate(data: AlertModel.init(title: "", type: .tableView([
                        AlertModel.TitleCellModel.init(title: "you have wone")
                    ]), buttons: [])))
                }
            }
        }
    }
    
    func loadRaund() {
        if loadingRound {
            return
        }
        if lvlanager.lvlBuilder.rounds <= lvlanager.progress.currentRound {
            print(lvlanager.progress.currentRound, "game completed ", lvlanager.lvlBuilder.rounds)
            if enemiesForce.isEmpty {
                didCompleteLevel()
            }
            return
        }
        print(lvlanager.progress.currentRound, " tefrwdsax ")
//        if lvlanager.lvlBuilder.enemyPerRound.count <= lvlanager.currentRound {
//            print("rfsdaefr")
//            return
//        }
        if enemies.count >= 1 {
            print("jkhdfsukhsakd ", enemies.count)
            return
        }
        if !canLoadRound {
            return
        }
        
        let totalCount = lvlanager.lvlBuilder
            .enemyPerRound[lvlanager.progress.currentRound].reduce(0) { partialResult, round in
                return round.count + partialResult
            }
        if totalCount >= 1 {
            self.canLoadRound = false
        }
        self.currentRoundCount = totalCount
        self.loadingRound = true
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: { [weak self] in
            guard let self else { return }
            self.performLoadRaund(totalCount)
        })
    }
    
    func performLoadRaund(_ totalNewEnemiesCount: Int) {
        var i = 0
        lvlanager.lvlBuilder
            .enemyPerRound[lvlanager.progress.currentRound]
            .forEach { type in
                (0..<type.count).forEach { _ in
                    self.loadEnemy(type.type, i: i, totalInRound: totalNewEnemiesCount)
                    i += 1
                }
               
        }
        lvlanager.progress.currentRound += 1
        if lvlanager.lvlModel.duration == .infinityRounds {
            lvlanager.progress.totalEnemies += totalNewEnemiesCount
        }
        if lvlanager.lvlModel.duration == .infinityRounds && lvlanager.progress.currentRound >= lvlanager.lvlBuilder.rounds - 1 {
            lvlanager.progress.roundRepeated += lvlanager.progress.currentRound
            lvlanager.progress.currentRound = 0
        }
        loadingRound = false
    }

}

fileprivate extension GameScene {
    var graundPath: CGMutablePath {
        guard let viewSize: CGSize = self.view?.frame.size else {
            return .init()
        }
        let path = CGMutablePath()
        
        let viewPos: CGPoint = .init(
            x: viewSize.width / -2 + 50,
            y: viewSize.height / -2 + 50)
        var positions = lvlanager.lvlBuilder
            .enemyGraundPosition
        path.move(to: CGPoint(x: (positions.first!.x * viewSize.width) + viewPos.x, y: (positions.first!.y * viewSize.height) + viewPos.y))
        positions.removeFirst()
        positions.forEach {
            path.addLine(to: CGPoint(
                x: ($0.x * viewSize.width) + viewPos.x,
                y: ($0.y * viewSize.height) + viewPos.y)
            )
        }
        return path
    }
    
    func updateGraundPosition() {
        enemyGround?.path = graundPath
    }
    
    func loadEnemy(_ type: EnemyType, i: Int, totalInRound: Int) {
        guard let path = enemyGround?.path else {
            return
        }
        let node = EnemyNode(type: type, builder: lvlanager.lvlBuilder, level: Int(lvlanager.lvlModel.levelPage) ?? 0, canPlaySound: canPlaySound)
        self.addChild(node)
        node.run(in: path, i: CGFloat(i), appeared: {
            if i + 1 >= totalInRound {
                self.canLoadRound = true
            }
        }, completion: {
            self.lvlanager.progress.health -= 1
            self.lvlanager.progress.passedEnemyCount += 1
            node.removeFromParent()
            self.loadRaund()
            if self.lvlanager.progress.health <= 0 {
                if self.levelCompleted {
                    return
                }
                if self.lvlanager.lvlModel.duration != .normal {
                    self.saveScore()
                }
                self.levelCompleted = true
                self.gameVC?.play(.loose)
                self.gameVC?.dismiss(animated: true) {
                    UIApplication.shared.activeWindow?.rootViewController?.present(vc: AlertViewController.initiate(data: AlertModel.init(title: "", type: .tableView([
                        AlertModel.TitleCellModel.init(title: "you have lost")
                    ]), buttons: [])))
                }
            }
        })
    }
        
    func loadBlockers() {
        lvlanager.lvlBuilder.blockers.forEach { blocker in
            let image = UIImage(named: blocker.type.assetName)
            var imageSize = image?.size ?? .zero
            if imageSize.width >= 150 || imageSize.height >= 150 {
                if imageSize.width > imageSize.height {
                    let percent = imageSize.height / imageSize.width
                    imageSize = .init(width: 150, height: 150 * percent)
                } else if imageSize.width < imageSize.height {
                    let percent = imageSize.height / imageSize.width
                    imageSize = .init(width: 150 * percent, height: 150)
                }
            }
            if imageSize == .zero {
                imageSize = .init(width: 20, height: 20)
            }
            print(imageSize, " hygfgdh")
            let node = SKSpriteNode(
                texture: .init(imageNamed: blocker.type.assetName),
                size: .init(
                    width: imageSize.width * blocker.sizeMultiplier,
                    height: imageSize.height * blocker.sizeMultiplier))
            node.name = "blockerNode"
            addChild(node)
        }
        updateBlockerPositions()
    }
    
    var viewSize: CGSize {
        guard var viewSize: CGSize = self.view?.frame.size else {
            return .zero
        }
        viewSize.width -= (self.view?.safeAreaInsets.left ?? 0) + (self.view?.safeAreaInsets.right ?? 0)
        viewSize.height -= (self.view?.safeAreaInsets.top ?? 0) + (self.view?.safeAreaInsets.bottom ?? 0)
        return viewSize
    }
    
    var viewPositionHelper: CGPoint {
        .init(
            x: viewSize.width / -2,
            y: viewSize.height / -2)
    }
    
    func updateBlockerPositions() {
        let viewSize = viewSize
        let viewPos = viewPositionHelper

        var i = 0
        let nodes = blockers
        
        lvlanager.lvlBuilder.blockers.forEach { blocker in
            var size = nodes[i].frame.size
            size.width *= blocker.sizeMultiplier
            size.height *= blocker.sizeMultiplier
            nodes[i].position = .init(
                x: (blocker.position.x * viewSize.width) + (viewPos.x),
                y: (blocker.position.y * viewSize.height) + (viewPos.y))
            i += 1
        }
    }
    
    var blockers: [SKNode] {
        children.filter({
            $0.name == "blockerNode"
        })
    }
    
    func loadGraund() {
        let shapeNode = SKShapeNode(path: .init(rect: .zero, transform: nil))
        shapeNode.name = Constants.Names.enemyGround.rawValue
        shapeNode.strokeColor = self.lvlanager.lvlBuilder.appearence.secondaryColor ?? page.appearence.secondaryColor!
        shapeNode.strokeTexture = .init(imageNamed: self.lvlanager.lvlBuilder.appearence.enemyGroundTextureName ?? page.appearence.enemyGroundTextureName!)
        shapeNode.lineWidth = Constants.graundWidth
        addChild(shapeNode)
        
        let shapeNode2 = SKShapeNode(path: .init(rect: .zero, transform: nil))
        shapeNode2.lineWidth = 2
        shapeNode2.strokeColor = .black.withAlphaComponent(0.15)
        shapeNode2.path = self.graundPath
        shapeNode.addChild(shapeNode2)
    }
    
    func loadSceneBackground() {
        if let name = self.lvlanager.lvlBuilder.appearence.backgroundTextureName ?? self.page.appearence.backgroundTextureName, !name.isEmpty {
            let sceneBackgroundNode = SKSpriteNode(texture: nil, size: size)
            sceneBackgroundNode.texture = .init(imageNamed: name)
            sceneBackgroundNode.color = lvlanager.lvlBuilder.appearence.backgroundColor ?? page.appearence.backgroundColor!
            sceneBackgroundNode.zPosition = -1
            sceneBackgroundNode.alpha = 0.2
            addChild(sceneBackgroundNode)
        }
        backgroundColor = lvlanager.lvlBuilder.appearence.backgroundColor ?? page.appearence.backgroundColor!
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let a = contact.bodyA.node
        let b = contact.bodyB.node
        if [a, b].contains(where: {
            $0 is EnemyNode
        }) && [a, b].contains(where: {
            $0 is WeaponNode
        }) {
            let enemy = a as? EnemyNode ?? b as! EnemyNode
            let armour = a as? WeaponNode ?? b as! WeaponNode
            armour.shoot(enemy: enemy, force: true)
        }
        if [a, b].contains(where: {
            $0 is BulletNode
        }) && [a, b].contains(where: {
            $0 is EnemyNode
        }) {
            let enemy = a as? EnemyNode ?? b as! EnemyNode
            let bullet = a as? BulletNode ?? b as! BulletNode
            let killed = enemy.bulletHitted(bullet)
            if killed && !enemy.isRemoving {
                lvlanager.progress.earnedMoney += enemy.totalHealth
                print(enemy.totalHealth, " grefdsxxv")
                lvlanager.progress.killedEnemies += 1
                enemy.removeFromParent()
                self.loadRaund()
            }
            bullet.removeFromParent()
        }
    }
}

extension GameScene {
    static func configure(
        lvl: LevelManager,
        page: LevelPagesBuilder,
        canPlaySound: Bool
    ) -> Self {
        let scene: Self = .init(fileNamed: Constants.Names.sceneName.rawValue)!
        scene.lvlanager = lvl
        scene.page = page
        scene.canPlaySound = canPlaySound
        return scene
    }
}

extension GameScene {
    struct Constants {
        static let graundWidth: CGFloat = 50
        
        enum Names: String {
            #warning("todo: remove scene from project, load empty scene")
            case sceneName = "GameScene"
            case enemyGround
        }
    }
}
