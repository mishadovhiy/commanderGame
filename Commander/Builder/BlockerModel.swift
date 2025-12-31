//
//  BlockerModel.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 30.12.2025.
//

import Foundation

extension GameBuilderModel {
    
    struct BlockerModel {
        let type: BlockerType
        let position: CGPoint
        let sizeMultiplier: CGFloat
        
        init(type: BlockerType,
             position: CGPoint,
             sizeMultiplier: CGFloat = 1) {
            self.type = type
            self.position = position
            self.sizeMultiplier = sizeMultiplier
        }
        
        enum BlockerType: String, CaseIterable {
            case tree1, tree2, tree3, tree4, tree5
            case tree6, tree7, tree8, tree9, tree10
            case bags, oil, helicopter
            case rock1, rock2, rock3
            case box1, box2
            case house1, house2, house3
            
            var mainComponentName: String {
                let number = rawValue.numbers
                return rawValue.replacingOccurrences(of: "\(number ?? 0)", with: "")
            }
            
            var assetName: String {
                let folder = "decorations/"
                guard let number = rawValue.numbers,
                        number >= 1 else {
                    return folder + rawValue
                }
                let numberStr = "\(number)"
                return folder + rawValue
                    .replacingOccurrences(of: numberStr, with: "") + "/" + numberStr
            }
        }
    }
}

extension [GameBuilderModel.BlockerModel] {
    static func allData(_ lvl: String) -> Self {
        switch lvl {
        default: [
//            .init(type: .tree6, position: .init(x: 0.2, y: 0.76)),
//            .init(type: .tree10, position: .init(x: 0.5, y: 0.55))
        ]
        }
        //house, treese > 5 - multipliwers
    }
}
