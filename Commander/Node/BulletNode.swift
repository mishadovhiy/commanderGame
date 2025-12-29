//
//  BulletNode.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 12.12.2025.
//

import SpriteKit

class BulletNode: SKSpriteNode {
    let damage: Int
    var armour: WeaponNode?
    private let fireTexture: FireTextureModel
        
    init(armour: WeaponNode) {
        fireTexture = .allAssets.randomElement()!
        self.damage = armour.damage
        self.armour = armour
        let texture: SKTexture?
        if armour.type.hasBullet {
            print("hasasasd")
            texture = .init(imageNamed: "fire\(fireTexture.i)/" + "1")
        } else {
            texture = nil
        }
        super.init(texture: texture, color: .blue, size: armour.type.bulletSize)
        self.physicsBody = .init(rectangleOf: .init(width: 10, height: 10))
        self.physicsBody?.categoryBitMask = PhysicsCategory.bullet
        self.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.affectedByGravity = false
        self.alpha = 0
    }
    
    func startShootAnimation() {
        self.alpha = 1
        run(.repeatForever(.animate(withNormalTextures: (0..<fireTexture.animationsCount).compactMap({
            .init(imageNamed: "fire\(fireTexture.i)/" + "\($0)")
        }), timePerFrame: 0.1)))
    }
    
    override func removeFromParent() {
        super.removeFromParent()
        armour = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate
extension BulletNode {
    struct FireTextureModel {
        let i: Int
        let animationsCount: Int
        
        static var allAssets: [Self] {
            (0..<1).compactMap({
                let assetsCount: Int
                switch $0 {
                default: assetsCount = 3
                }
                return .init(i: $0 + 1, animationsCount: assetsCount)
            })
        }
    }

}
