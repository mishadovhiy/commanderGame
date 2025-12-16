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
        super.init(texture: .init(imageNamed: "enemy/" + type.imageName), color: .clear, size: CGSize(width: 20, height: 20))
        self.name = .init(describing: Self.self)
        self.physicsBody = .init(rectangleOf: size)
        self.physicsBody?.categoryBitMask = PhysicsCategory.enemy
        self.physicsBody?.contactTestBitMask = PhysicsCategory.weapon | PhysicsCategory.bullet
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.affectedByGravity = false
        
        let progress = SKSpriteNode(texture: nil, color: .green, size: .init(width: self.size.width, height: 4))
        progress.name = "progress"
        progress.position = .init(x: 0, y: self.size.height / -2 - 3)
        progress.zPosition = 1
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
            
            let explosure = SKSpriteNode(texture: .init(image: .hit), size: .init(width: 15, height: 15))
            explosure.alpha = 0.5
            addChild(explosure)
            explosure.run(.scale(to: 1, duration: 0.17))
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(170), execute: {
                explosure.run(.fadeOut(withDuration: 0.2))
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200), execute: {
                    explosure.removeFromParent()
                })
            })
            
            return false
        } else {
            return true
        }
    }
    
    var isRemoving: Bool {
        children.contains(where: {
            $0.name == "explosure"
        })
    }
    
    override func removeFromParent() {
        let explosure = SKSpriteNode(texture: .init(image: .exposure), size: .init(width: 5, height: 5))
        explosure.name = "explosure"
        addChild(explosure)
        explosure.run(.scale(to: 10, duration: 0.2))
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200), execute: {
            self.texture = nil
            explosure.run(.fadeOut(withDuration: 0.3))
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: {
                explosure.removeFromParent()
                super.removeFromParent()
            })
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
