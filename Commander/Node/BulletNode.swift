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
    
    init(armour: WeaponNode) {
        self.damage = armour.damage
        self.armour = armour
        super.init(texture: nil, color: .blue, size: .init(width: 10, height: 10))
        self.physicsBody = .init(rectangleOf: .init(width: 10, height: 10))
        self.physicsBody?.categoryBitMask = PhysicsCategory.bullet
        self.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.affectedByGravity = false
    }
    
    override func removeFromParent() {
        super.removeFromParent()
        armour = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
