//
//  AppearenceGameBuilderModel.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 30.12.2025.
//

import UIKit

struct AppearenceGameBuilderModel: Equatable {
    let backgroundColor: UIColor?
    let secondaryColor: UIColor?
    
    let backgroundTextureName: String?
    let enemyGroundTextureName: String?
    
    init(backgroundColor: UIColor? = nil,
         secondaryColor: UIColor? = nil,
         backgroundTextureName: String? = nil,
         enemyGroundTextureName: String? = nil) {
        self.backgroundColor = backgroundColor
        self.secondaryColor = secondaryColor
        self.backgroundTextureName = backgroundTextureName
        self.enemyGroundTextureName = enemyGroundTextureName
    }
}
