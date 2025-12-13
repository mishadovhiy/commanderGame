//
//  GameScene.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 11.12.2025.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var lvlanager: LevelManager!
    
    private var gameVC: GameViewController? {
        view?.next as? GameViewController
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        physicsWorld.contactDelegate = self
        loadGraund()
        updateGraundPosition()
        loadArmour(position: .init(x: 0.186, y: 0.22))
        loadArmour(position: .init(x: 0.271, y: 0.22))

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            self.loadRaund()
        })
    }
        
    var enemyGround: SKShapeNode? {
        children.first(where: {
            $0.name == Constants.Names.enemyGround.rawValue
        }) as? SKShapeNode
    }
    
    var enemies: [EnemyNode] {
        self.children.filter({
            $0 is EnemyNode
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        weapons.forEach({
            $0.isEditing = false
        })
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        guard let weapon = atPoint(location) as? WeaponNode else { return }
        weapon.isEditing.toggle()
        gameVC?.didSetEditingWeaponNode()
    }
    
    func loadArmour(position: CGPoint) {
        let node = WeaponNode(type: .basuka)
        self.addChild(node)
        node.updatePosition(position: position)
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
    
    func loadEnemy(_ type: EnemyType) {
        let node = EnemyNode(type: type, builder: lvlanager.lvlBuilder)
        self.addChild(node)
        node.run(in: graundPath, completion: {
            node.removeFromParent()
            self.loadRaund()
        })
        print("rfsedaXZ")
    }
    
    func loadRaund() {
        print(lvlanager.currentRound, " tefrwdsax ")
        if lvlanager.lvlBuilder.enemyPerRound.count <= lvlanager.currentRound {
            print("game completed")
            return
        }
        if enemies.count >= 1 {
            return
        }
        
        print(lvlanager.currentRound, " tefrwdsax")
        if lvlanager.lvlBuilder.enemyPerRound.count <= lvlanager.currentRound {
            print("game completed")
            return
        }
        var i = 0
        lvlanager.lvlBuilder
            .enemyPerRound[lvlanager.currentRound]
            .forEach { type in
                i += 1
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1100 * i), execute: {
                    self.loadEnemy(type.type)
                })
        }
        lvlanager.currentRound += 1
    }
    
    func loadGraund() {
        let shapeNode = SKShapeNode(path: .init(rect: .zero, transform: nil))
        shapeNode.name = Constants.Names.enemyGround.rawValue
        shapeNode.strokeColor = .white
        shapeNode.lineWidth = Constants.graundWidth
        shapeNode.path = graundPath
        addChild(shapeNode)
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
//                self.loadEnemy()
                if let next = bullet.armour?.nextEnemyHolder {
                    bullet.armour?.shoot(enemy: next)
                }
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
