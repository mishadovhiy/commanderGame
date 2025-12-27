//
//  GameScene.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 11.12.2025.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var lvlanager: LevelManager! {
        didSet {
            gameVC?.roundLabel.text = "\(lvlanager.currentRound)/\(lvlanager.lvlBuilder.rounds)"
            gameVC?.healthLabel.text = "\(lvlanager.progress.health)"
            gameVC?.balanceLabel.text = "\(lvlanager.progress.earnedMoney)"
        }
    }
    
    private var gameVC: GameViewController? {
        view?.next as? GameViewController
    }

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        physicsWorld.contactDelegate = self
        loadGraund()
        updateGraundPosition()
        loadArmour(type: .granata, position: .init(x: 0.186, y: 0.22))
        loadArmour(type: .pistol, position: .init(x: 0.271, y: 0.22))
        self.weapons.forEach({
            print($0.position, " tgerfwdas")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            self.loadRaund()
        })
        
        backgroundColor = .init(hex: "E7D4A9")
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

        return true
    }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        weapons.forEach({
            $0.isEditing = false
        })
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        if let weapon = atPoint(location) as? WeaponNode {
            weapon.isEditing.toggle()
            gameVC?.didSetEditingWeaponNode()
        }
        
    }
    
    func loadArmour(type: WeaponType, position: CGPoint) {
        let node = WeaponNode(type: type)
        self.addChild(node)
        node.updatePosition(position: position)
    }
    
    func didCompleteLevel() {
        let levelManager = self.lvlanager ?? .init(.test)
        DispatchQueue(label: "db", qos: .userInitiated).async {
            DataBaseService.db.completedLevels.updateValue(levelManager.progress, forKey: levelManager.lvlModel)
            #warning("save new balance to keychain")
            print("game completed ", levelManager.lvlModel)
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
        if lvlanager.lvlBuilder.rounds <= lvlanager.currentRound {
            print("game completed")
            if enemies.isEmpty {
                didCompleteLevel()
            }
            return
        }
        print(lvlanager.currentRound, " tefrwdsax ")
//        if lvlanager.lvlBuilder.enemyPerRound.count <= lvlanager.currentRound {
//            print("rfsdaefr")
//            return
//        }
        if enemies.count >= 1 {
            print("jkhdfsukhsakd ", enemies.count)
            return
        }
        
        print(lvlanager.currentRound, " tefrwdsax")
        var i = 0
        lvlanager.lvlBuilder
            .enemyPerRound[lvlanager.currentRound]
            .forEach { type in
                self.loadEnemy(type.type, i: i)
                i += 1
        }
        lvlanager.currentRound += 1
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
        path.move(to: CGPoint(x: 0 + viewPos.x, y: 0 + viewPos.y))
        
        lvlanager.lvlBuilder
            .enemyGraundPosition
            .forEach {
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
    
    func loadEnemy(_ type: EnemyType, i: Int) {
        guard let path = enemyGround?.path else {
            return
        }
        let node = EnemyNode(type: type, builder: lvlanager.lvlBuilder)
        self.addChild(node)
        node.run(in: path, i: CGFloat(i), completion: {
            self.lvlanager.progress.health -= 1
            self.lvlanager.progress.passedEnemyCount += 1
            node.removeFromParent()
            self.loadRaund()
            if self.lvlanager.progress.health <= 0 {
                self.gameVC?.play(.loose)
                self.gameVC?.dismiss(animated: true) {
                    UIApplication.shared.activeWindow?.rootViewController?.present(vc: AlertViewController.initiate(data: AlertModel.init(title: "", type: .tableView([
                        AlertModel.TitleCellModel.init(title: "you have lost")
                    ]), buttons: [])))
                }
            }
        })
    }
        
    func loadGraund() {
        let shapeNode = SKShapeNode(path: .init(rect: .zero, transform: nil))
        shapeNode.name = Constants.Names.enemyGround.rawValue
        shapeNode.strokeColor = .init(hex: "D0A976")
        shapeNode.strokeTexture = .init(image: .enemyGround)
        shapeNode.lineWidth = Constants.graundWidth
        addChild(shapeNode)
        
        let shapeNode2 = SKShapeNode(path: .init(rect: .zero, transform: nil))
        shapeNode2.lineWidth = 2
        shapeNode2.strokeColor = .init(hex: "B89668")
        shapeNode2.path = self.graundPath
        shapeNode.addChild(shapeNode2)
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
            print("contadsx")
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
            if killed {
                lvlanager.progress.earnedMoney += enemy.totalHealth
                lvlanager.progress.killedEnemies += 1
                enemy.removeFromParent()
                self.loadRaund()
            } else {
            }
            bullet.removeFromParent()
        }
    }
}

extension GameScene {
    static func configure(lvl: LevelManager) -> Self {
        let scene: Self = .init(fileNamed: Constants.Names.sceneName.rawValue)!
        scene.lvlanager = lvl
        return scene
    }
}

extension GameScene {
    struct Constants {
        static let graundWidth: CGFloat = 50
        
        enum Names: String {
            case sceneName = "GameScene"
            case enemyGround
        }
    }
}
