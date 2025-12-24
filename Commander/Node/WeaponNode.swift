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
    
    var targetEnemy: EnemyNode?
    var nextEnemyHolder: EnemyNode? {
        (parent as? GameScene)?.enemies.last(where: {
            self.intersects($0)
        })
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
        self.addChild(child)
    }
    
    func updatePosition(position: CGPoint) {
        guard let viewSize = (parent as? SKScene)?.view?.frame.size else {
            fatalError()
        }
        self.position = .init(
            x: (position.x * viewSize.width) - (viewSize.width / 2),
            y: (position.y * viewSize.height) - (viewSize.height / 2))
        bullets?.forEach {
            $0?.removeFromParent()
        }
        addBullet()
    }
      
    func setEditing() {
        self.color = (!isEditing ? UIColor.clear : UIColor.green).withAlphaComponent(0.2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WeaponNode {
    private func addBullet() {
        let count = (upgrade?.index ?? 0) + 1
        Array(0..<count).forEach { i in
            performAddSingleBullet(i: i, total: count)
        }
    }
    
    private func performAddSingleBullet(i: Int, total: Int) {
        let bullet = BulletNode(armour: self)
        bullet.position = .init(x: position.x + CGFloat(i * 5) - ((CGFloat(total) / 2) * 5), y: position.y)
        (parent as? SKScene)?.addChild(bullet)
        bullet.zPosition = 999
    }
    
    private var bullets: [BulletNode?]? {
        (parent as? SKScene)?.children.filter({
            ($0 as? BulletNode)?.armour == self
        }) as? [BulletNode]
    }
    
    func addFireNode() {
        let fire = SKSpriteNode(texture: .init(image: .fire), size: .init(width: 10, height: 10))
        addChild(fire)
        fire.run(.fadeOut(withDuration: 0.3))
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: {
            fire.removeFromParent()
        })
    }
    
    func shoot(enemy: EnemyNode, force: Bool = false) {
        if !canShoot(enemy, force: force) {
            return
        }
        if self.parent?.isPaused ?? true == false {
            self.performShoot(enemy)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
            self.addBullet()

            self.targetEnemy = nil
            self.shoot(enemy: enemy)
        })
    }
    
    private func canShoot(_ enemy: EnemyNode, force: Bool) -> Bool {
        if targetEnemy != enemy && targetEnemy != nil && self.parent != nil {
            return false
        }
        if enemy.parent == nil || enemy.isRemoving {
            targetEnemy = nil
            if let nextEnemyHolder {
                self.shoot(enemy: nextEnemyHolder)
            }
            return false
        }
        self.targetEnemy = enemy
        if !force && !self.intersects(enemy) {
            self.targetEnemy = nil
            if let nextEnemyHolder {
                self.shoot(enemy: nextEnemyHolder)
            }
            return false
        }
        return true
    }
    
    private func performShoot(_ enemy: EnemyNode) {
        if let bullets = self.bullets, bullets.count >= 1 {
            let dx = enemy.position.x - self.position.x
            let dy = enemy.position.y - self.position.y
            let direction = CGVector(dx: dx, dy: dy)
            addFireNode()
            bullets.forEach { bullet in
                bullet?.run(.applyImpulse(direction, duration: 8.3))
            }
        }
    }
}
