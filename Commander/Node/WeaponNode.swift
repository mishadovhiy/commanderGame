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
    
    init(type: WeaponType) {
        self.type = type
        self.damage = type.damage
        super.init(texture: nil, color: .red.withAlphaComponent(0.2), size: CGSize(width: 100, height: 100))
        
        self.physicsBody = .init(rectangleOf: .init(width: 100, height: 100))
        self.physicsBody?.categoryBitMask = PhysicsCategory.weapon
        self.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.affectedByGravity = false
        let child = SKSpriteNode(color: .red, size: CGSize(width: 20, height: 20))
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
    var nextEnemyHolder: EnemyNode?
    
    func shoot(enemy: EnemyNode, force: Bool = false) {
        if targetEnemy != enemy && targetEnemy != nil {
            nextEnemyHolder = enemy
            return
        }
        if enemy.parent == nil {
            print(targetEnemy == nil, " refwda")
            targetEnemy = nil
            if let nextEnemyHolder {
                self.nextEnemyHolder = nil
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
                self.nextEnemyHolder = nil
                self.shoot(enemy: nextEnemyHolder)
            }
            return
        }
        parent.addChild(bullet)
//        if (dx >= 80 || dx <= -80) || (dy >= 80 || dy <= -80) {
//            print("outside")
//            self.targetEnemy = nil
//            return
//        }
        let direction = CGVector(dx: dx, dy: dy)

        bullet.physicsBody?.applyImpulse(
            CGVector(dx: direction.dx * 0.01, dy: direction.dy * 0.01)
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
            self.targetEnemy = nil
            self.shoot(enemy: enemy)
        })
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
