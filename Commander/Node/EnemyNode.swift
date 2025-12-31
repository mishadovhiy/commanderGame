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
        let level = Float(builder.enemyHealthMult)
        self.health = (type.health * Int(level))
        self.totalHealth = health
        super.init(texture: .init(imageNamed: "enemy/" + type.component.rawValue + "/1"), color: .clear, size: CGSize(width: 20, height: 20))
        addChild(AudioContainerNode(audioNames: [.explosure1, .explosure3, .explosure4, .explosure, .hit1, .hit2, .coins]))
        self.zRotation = .pi
        self.name = .init(describing: Self.self)
        self.physicsBody = .init(rectangleOf: size)
        self.physicsBody?.categoryBitMask = PhysicsCategory.enemy
        self.physicsBody?.contactTestBitMask = PhysicsCategory.weapon | PhysicsCategory.bullet
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.affectedByGravity = false
        let assets = type.assetAnimations
        if assets.run > 1 {
            let textures: [SKTexture] = Array(1..<assets.run)
                .compactMap({
                    let name = "enemy/" + type.component.rawValue
                    return .init(imageNamed: name + "/\($0)")
            })
            let action = SKAction.animate(with: textures, timePerFrame: 0.1)
            self.run(.repeatForever(action), withKey: Constants.ActionNames.run.rawValue)
        }
        let progress = SKSpriteNode(texture: nil, color: .green, size: .init(width: self.size.width, height: 4))
        progress.name = "progress"
        progress.position = .init(x: 0, y: self.size.height / -2 - 3)
        progress.zPosition = 1
//        self.isRemoving = true
        addChild(progress)
        self.alpha = 0
    }
//    private var isAdded: Bool = false
    var audioContainer: AudioContainerNode? {
        children.first(where:  {
            $0 is AudioContainerNode
        }) as? AudioContainerNode
    }
    
    func run(in shape: CGPath, i: CGFloat, appeared: @escaping()->(), completion: @escaping()->()) {
        self.position.x = (parent?.frame.size.width ?? 0) * -4
        
        let delay = SKAction.wait(forDuration: i * 2.0)
        let fade = SKAction.fadeAlpha(to: 1, duration: 0.5)
        let followPath = SKAction.follow(shape, asOffset: false, orientToPath: true, duration: 70)
        self.run(.sequence([delay, followPath]), completion: completion)
        self.run(.sequence([delay, SKAction.wait(forDuration: 2.0), fade])) {
            appeared()
//            self.isRemoving = false
        }

    }
    
    func bulletHitted(_ bullet: BulletNode) -> Bool {
        guard let progress = children.first(where: {
            $0.name == "progress"
        }) as? SKSpriteNode else {
            return false
        }
        print(bullet.damage, " ", health)
        audioContainer?.play(.hit1)
        health -= bullet.damage
        let newPercent = CGFloat(health) / CGFloat(totalHealth)
        if newPercent > 0 {
            progress.size = .init(width: self.size.width * newPercent, height: 4)
            let assets = type.assetAnimations
            if assets.damaged >= 1 {
                let newAssetIndex = CGFloat(assets.damaged) * newPercent
                if let image = UIImage(named: "enemy/" + type.component.rawValue + "/damaged/" + "\(Int(newAssetIndex))") {
                    self.texture = .init(image: image)
                } else {
                    print("noimageforasset ", Int(newAssetIndex))
                }
            }
            let explosure = SKSpriteNode(texture: .init(image: .hit), size: .init(width: 15, height: 15))
            explosure.alpha = 0.5
            addChild(explosure)
            explosure.run(.scale(to: 1, duration: 0.17))
            self.run(.wait(forDuration: 0.17)) {
                explosure.run(.fadeOut(withDuration: 0.2))
                self.run(.wait(forDuration: 0.2)) {
                    explosure.removeFromParent()
                }
            }
            
            return false
        } else {
            return true
        }
    }
    
    var isRemoving: Bool {
        alpha == 0 || children.contains(where: {
            $0.name == "explosure"
        })
    }
    
    override func removeFromParent() {
        if isRemoving {
            return
        }
        self.removeAllActions()
        audioContainer?.play(.explosure1)
        let explosure = SKSpriteNode(texture: .init(image: .exposure), size: .init(width: 5, height: 5))
        explosure.name = "explosure"
        addChild(explosure)
        explosure.run(.scale(to: 10, duration: 0.2))
        self.run(.wait(forDuration: 0.2)) {
            self.performDieAnimation {
                self.addCoin()
                self.texture = nil
                explosure.run(.fadeOut(withDuration: 0.3))
                self.run(.wait(forDuration: 0.3)) {
                    explosure.removeFromParent()
                    self.children.forEach {
                        $0.removeFromParent()
                    }
                    super.removeFromParent()
                }
            }
        }
    }
    
    func addCoin() {
        self.audioContainer?.play(.coins)
        let node = SKSpriteNode(texture: .init(image: .coin), color: .clear, size: .init(width: 10, height: 10))
        node.position = position
        parent?.addChild(node)
        node.run(.sequence([
            .wait(forDuration: 0.12),
            .fadeOut(withDuration: 0.18)
        ]))
        node.run(.sequence([
            .moveBy(x: 0, y: 50, duration: 0.3),
            .wait(forDuration: 0.3)
        ])) {
            node.removeFromParent()
        }
    }
    
    private func performDieAnimation(
        completion: @escaping()->()) {
            let assets = type.assetAnimations
            if assets.die >= 1 {
                self.removeAction(
                    forKey: Constants.ActionNames.run.rawValue)
                let textures: [SKTexture] = Array(1..<assets.die)
                    .compactMap({
                        let name = "enemy/" + type.component.rawValue
                        return .init(imageNamed: name + "/die" + "/\($0)")
                })
                let action = SKAction.animate(with: textures, timePerFrame: 0.2)
                self.run(action) {
                    completion()
                }
            } else {
                completion()
            }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EnemyNode {
    struct Constants {
        enum ActionNames: String {
            case run
        }
    }
}
