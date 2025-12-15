//
//  EnemyNode.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 11.12.2025.
//

import SpriteKit

class EnemyNode: SKSpriteNode {
    let type: EnemyType
    var health: Int
    var totalHealth: Int
    
    init(type: EnemyType, builder: GameBuilderModel) {
        self.type = type
        self.health = (type.health * builder.enemyHealthMult) * 3
        self.totalHealth = health
        super.init(texture: nil, color: .red, size: CGSize(width: 20, height: 20))
        self.physicsBody = .init(rectangleOf: .init(width: 20, height: 20))
        self.physicsBody?.categoryBitMask = PhysicsCategory.enemy
        self.physicsBody?.contactTestBitMask = PhysicsCategory.weapon | PhysicsCategory.bullet
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.affectedByGravity = false
        
        let progress = SKSpriteNode(texture: nil, color: .green, size: .init(width: self.size.width, height: 4))
        progress.name = "progress"
        addChild(progress)
    }
    
    func run(in shape: CGPath, completion: @escaping()->()) {
        let followPath = SKAction.follow(shape, asOffset: false, orientToPath: true, duration: 70)
        self.run(followPath, completion: completion)
    }
    
    func bulletHitted(_ bullet: BulletNode) -> Bool {
        guard let progress = children.first(where: {
            $0.name == "progress"
        }) as? SKSpriteNode else {
            return false
        }
        print(bullet.damage, " ", health)

        health -= bullet.damage
        let new = CGFloat(health) / CGFloat(totalHealth)
        if new > 0 {
            progress.size = .init(width: self.size.width * new, height: 4)
            return false
        } else {
            return true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
