//
//  ArmourNode.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 11.12.2025.
//

import SpriteKit

class WeaponNode: SKSpriteNode {
    
    let type: WeaponType
    let damage: Int
    var upgrade: Difficulty? = nil
    var upgradePrice: Int {
        type.upgradeStepPrice * ((upgrade?.index ?? -1) + 2)
    }
    var canUpgrade: Bool {
        (upgrade?.index ?? 0) < (Difficulty.allCases.count - 1)
    }
    var isEditing: Bool = false {
        didSet {
            setEditing()
        }
    }
    
    init(type: WeaponType) {
        self.type = type
        self.damage = type.damage * 4
        super.init(texture: nil, color: .clear, size: CGSize(width: 100, height: 100))
        self.name = .init(describing: Self.self)

        self.physicsBody = .init(rectangleOf: .init(width: 100, height: 100))
        self.physicsBody?.categoryBitMask = PhysicsCategory.weapon
        self.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.affectedByGravity = false
        let child = SKSpriteNode(texture: .init(imageNamed: type.rawValue), color: .clear, size: .init(width: 20, height: 20))
        //SKSpriteNode(color: .red, size: CGSize(width: 20, height: 20))
        self.addChild(child)
        
    }
    
    func updatePosition(position: CGPoint) {
        guard let viewSize = (parent as? SKScene)?.view?.frame.size else {
            fatalError()
        }
        self.position = .init(
            x: (position.x * viewSize.width) - (viewSize.width / 2),
            y: (position.y * viewSize.height) - (viewSize.height / 2))
    }
    
    var targetEnemy: EnemyNode?
    var nextEnemyHolder: EnemyNode? {
        (parent as? GameScene)?.enemies.last(where: {
            self.intersects($0)
        })
    }
    
    func shoot(enemy: EnemyNode, force: Bool = false) {
        if targetEnemy != enemy && targetEnemy != nil {
//            nextEnemyHolder = enemy
            return
        }
        if enemy.parent == nil || enemy.isRemoving {
            print(targetEnemy == nil, " refwda")
            targetEnemy = nil
            if let nextEnemyHolder {
//                self.nextEnemyHolder = nil
                self.shoot(enemy: nextEnemyHolder)
            }
            return
        }
        self.targetEnemy = enemy
        let bullet = BulletNode(armour: self)
        bullet.position = self.position
        guard let parent = parent as? SKScene else {
            fatalError()
        }
        let dx = enemy.position.x - self.position.x
        let dy = enemy.position.y - self.position.y
        print(dx, " egrfweda ", dy)
        if !force && !self.intersects(enemy) {
            print("outside")
            self.targetEnemy = nil
            if let nextEnemyHolder {
//                self.nextEnemyHolder = nil
                self.shoot(enemy: nextEnemyHolder)
            }
            return
        }
        parent.addChild(bullet)
        let fire = SKSpriteNode(texture: .init(image: .fire), size: .init(width: 10, height: 10))
        addChild(fire)
        fire.run(.fadeOut(withDuration: 0.3))
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: {
            fire.removeFromParent()
        })
        let direction = CGVector(dx: dx, dy: dy)
        bullet.run(.applyImpulse(direction, duration: 8.3))
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
            self.targetEnemy = nil
            self.shoot(enemy: enemy)
        })
    }
        
    func setEditing() {
        self.color = (!isEditing ? UIColor.clear : UIColor.green).withAlphaComponent(0.2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
