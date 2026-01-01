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
        case "11":
            [
                .init(type: .tree8, position: .init(x: 0.2, y: 0.2)),
                .init(type: .house1, position: .init(x: 0.3, y: 0.4), sizeMultiplier: 0.4),
                .init(type: .house2, position: .init(x: 0.7, y: 0.8), sizeMultiplier: 1)
            ]
        case "302":
            [
                .init(type: .tree7, position: .init(x: 0.15, y: 0.2)),
                .init(type: .house2, position: .init(x: 0.76, y: 0.8)),
                .init(type: .box1, position: .init(x: 0.55, y: 0.8)),
                .init(type: .tree4, position: .init(x: 0.35, y: 0.2)),
                .init(type: .tree8, position: .init(x: 0.45, y: 0.2)),
                .init(type: .oil, position: .init(x: 0.365, y: 0.26))
            ]
        case "303":
            [
                .init(type: .tree5, position: .init(x: 0.4, y: 0.5), sizeMultiplier: 2.3),
                .init(type: .house3, position: .init(x: 0.55, y: 0.6)),
                .init(type: .tree7, position: .init(x: 0.42, y: 0.77)),
                .init(type: .box2, position: .init(x: 0.8, y: 0.5)),
                .init(type: .box1, position: .init(x: 0.74, y: 0.45)),
                .init(type: .box2, position: .init(x: 0.85, y: 0.47)),
                .init(type: .tree7, position: .init(x: 0.8, y: 0.27))
            ]
        case "304":
            [
                .init(type: .house2, position: .init(x: 0.4, y: 0.5)),
                .init(type: .tree6, position: .init(x: 0.14, y: 0.6)),
                .init(type: .tree8, position: .init(x: 0.8, y: 0.6)),
                .init(type: .tree4, position: .init(x: 0.9, y: 0.52)),
                .init(type: .tree5, position: .init(x: 0.86, y: 0.45))
            ]
        case "305":
            [
                .init(type: .tree5, position: .init(x: 0.15, y: 0.6)),
                .init(type: .helicopter, position: .init(x: 0.45, y: 0.75)),
                .init(type: .tree6, position: .init(x: 0.5, y: 0.6)),
                .init(type: .tree9, position: .init(x: 0.74, y: 0.52)),
                .init(type: .tree8, position: .init(x: 0.58, y: 0.465))
            ]
        case "306":
            [
                .init(type: .tree6, position: .init(x: 0.1, y: 0.8)),
                .init(type: .tree8, position: .init(x: 0.8, y: 0.85)),
                .init(type: .tree6, position: .init(x: 0.35, y: 0.2)),

            ]
        case "307":
            [
                .init(type: .tree6, position: .init(x: 0.45, y: 0.35)),
                .init(type: .tree6, position: .init(x: 0.485, y: 0.423)),
                .init(type: .tree8, position: .init(x: 0.6, y: 0.46)),
                .init(type: .box2, position: .init(x: 0.73, y: 0.42))

            ]
        case "308":
            [
                .init(type: .house2, position: .init(x: 0.3, y: 0.3)),
                .init(type: .tree6, position: .init(x: 0.5, y: 0.4)),
                .init(type: .tree9, position: .init(x: 0.7, y: 0.34)),
                .init(type: .tree6, position: .init(x: 0.53, y: 0.24))

            ]
        case "309":
            [
                .init(type: .tree9, position: .init(x: 0.4, y: 0.7)),
                .init(type: .tree6, position: .init(x: 0.5, y: 0.55)),
                .init(type: .tree6, position: .init(x: 0.55, y: 0.65)),
                .init(type: .house1, position: .init(x: 0.82, y: 0.4))
            ]
        case "310":
            [
                .init(type: .house2, position: .init(x: 0.2, y: 0.75)),
                .init(type: .tree6, position: .init(x: 0.7, y: 0.4)),
                .init(type: .tree9, position: .init(x: 0.8, y: 0.34)),
                .init(type: .tree6, position: .init(x: 0.53, y: 0.24))

            ]
        case "311":
            [
                .init(type: .house2, position: .init(x: 0.2, y: 0.65)),
                .init(type: .house3, position: .init(x: 0.5, y: 0.5)),
                .init(type: .tree6, position: .init(x: 0.34, y: 0.7)),
                .init(type: .tree8, position: .init(x: 0.47, y: 0.74)),
                .init(type: .tree6, position: .init(x: 0.15, y: 0.4)),
                .init(type: .tree6, position: .init(x: 0.33, y: 0.6)),

            ]
        case "401":
            [
                .init(type: .house1, position: .init(x: 0.25, y: 0.56)),
                .init(type: .tree6, position: .init(x: 0.15, y: 0.8)),
                .init(type: .tree4, position: .init(x: 0.13, y: 0.7)),
                .init(type: .tree6, position: .init(x: 0.21, y: 0.78)),
                .init(type: .helicopter, position: .init(x: 0.6, y: 0.3)),
                .init(type: .tree8, position: .init(x: 0.81, y: 0.34)),
                .init(type: .tree4, position: .init(x: 0.68, y: 0.7)),

            ]
        case "402":
            [
                .init(type: .house2, position: .init(x: 0.2, y: 0.8)),
                .init(type: .tree7, position: .init(x: 0.14, y: 0.3)),
                .init(type: .tree4, position: .init(x: 0.21, y: 0.4)),
                .init(type: .tree5, position: .init(x: 0.85, y: 0.8), sizeMultiplier: 2)
            ]
        case "403":
            [
                .init(type: .box1, position: .init(x: 0.15, y: 0.8)),
                .init(type: .rock2, position: .init(x: 0.3, y: 0.5)),
                .init(type: .tree8, position: .init(x: 0.19, y: 0.62)),
                .init(type: .helicopter, position: .init(x: 0.7, y: 0.4)),
                .init(type: .tree4, position: .init(x: 0.65, y: 0.75)),
                .init(type: .tree9, position: .init(x: 0.8, y: 0.67)),
                .init(type: .tree7, position: .init(x: 0.5, y: 0.3))
            ]
        case "404":
            [
                .init(type: .tree6, position: .init(x: 0.33, y: 0.42)),
                .init(type: .tree4, position: .init(x: 0.4, y: 0.6)),
                .init(type: .tree7, position: .init(x: 0.5, y: 0.46)),
                .init(type: .house1, position: .init(x: 0.7, y: 0.47)),
                .init(type: .oil, position: .init(x: 0.45, y: 0.65))
            ]
        case "405":
            [
                .init(type: .house1, position: .init(x: 0.21, y: 0.6)),
                .init(type: .tree6, position: .init(x: 0.45, y: 0.3)),
                .init(type: .tree7, position: .init(x: 0.6, y: 0.33)),
                .init(type: .tree6, position: .init(x: 0.65, y: 0.56))
            ]
        case "406":
            [
                .init(type: .rock2, position: .init(x: 0.2, y: 0.3)),
                .init(type: .tree7, position: .init(x: 0.4, y: 0.3)),
                .init(type: .tree6, position: .init(x: 0.5, y: 0.4)),
                .init(type: .tree7, position: .init(x: 0.7, y: 0.4)),
                .init(type: .tree4, position: .init(x: 0.65, y: 0.8))
            ]
        case "407":
            [
                .init(type: .tree8, position: .init(x: 0.2, y: 0.45)),

                .init(type: .tree4, position: .init(x: 0.4, y: 0.43)),
                .init(type: .tree6, position: .init(x: 0.3, y: 0.4)),
                .init(type: .rock2, position: .init(x: 0.5, y: 0.4)),
                .init(type: .tree8, position: .init(x: 0.7, y: 0.35))
            ]
        case "408":
            [
                .init(type: .tree8, position: .init(x: 0.2, y: 0.3)),
                .init(type: .tree6, position: .init(x: 0.3, y: 0.41)),
                .init(type: .house1, position: .init(x: 0.75, y: 0.88))
            ]
        case "409":
            [
                .init(type: .rock1, position: .init(x: 0.15, y: 0.4)),
                .init(type: .tree6, position: .init(x: 0.4, y: 0.34)),
                .init(type: .tree8, position: .init(x: 0.55, y: 0.48))
            ]
        case "410":
            [
                .init(type: .house2, position: .init(x: 0.5, y: 0.4)),
                .init(type: .tree8, position: .init(x: 0.8, y: 0.7)),
                .init(type: .tree4, position: .init(x: 0.35, y: 0.5)),
                .init(type: .rock3, position: .init(x: 0.8, y: 0.48)),
                .init(type: .tree6, position: .init(x: 0.55, y: 0.55)),
                .init(type: .tree5, position: .init(x: 0.42, y: 0.6)),
                .init(type: .bags, position: .init(x: 0.38, y: 0.2))
            ]
        case "411":
            [
                .init(type: .tree4, position: .init(x: 0.16, y: 0.5)),
                .init(type: .tree4, position: .init(x: 0.12, y: 0.36)),
                .init(type: .helicopter, position: .init(x: 0.43, y: 0.56)),
                .init(type: .tree6, position: .init(x: 0.58, y: 0.7)),
                .init(type: .tree9, position: .init(x: 0.8, y: 0.43)),
                .init(type: .tree7, position: .init(x: 0.47, y: 0.8)),
                .init(type: .tree5, position: .init(x: 0.35, y: 0.2))
            ]
        case "412":
            [
                .init(type: .house2, position: .init(x: 0.18, y: 0.3)),
                .init(type: .tree9, position: .init(x: 0.23, y: 0.6)),
                .init(type: .box1, position: .init(x: 0.4, y: 0.8)),
                .init(type: .rock3, position: .init(x: 0.25, y: 0.13)),
                .init(type: .tree8, position: .init(x: 0.4, y: 0.55)),
                .init(type: .tree7, position: .init(x: 0.55, y: 0.56)),
                .init(type: .tree4, position: .init(x: 0.19, y: 0.8)),
                .init(type: .tree4, position: .init(x: 0.5, y: 0.8))
            ]
        case "12":
            [
                .init(type: .tree8, position: .init(x: 0.5, y: 0.3)),
                .init(type: .house1, position: .init(x: 0.4, y: 0.4385), sizeMultiplier: 0.4),
                .init(type: .house2, position: .init(x: 0.842, y: 0.7123), sizeMultiplier: 1),
                .init(type: .tree4, position: .init(x: 0.176, y: 0.8)),
                .init(type: .tree6, position: .init(x: 0.5, y: 0.55)),
                .init(type: .tree4, position: .init(x: 0.84, y: 0.5)),
                .init(type: .oil, position: .init(x: 4, y: 0.5)),
                .init(type: .box1, position: .init(x: 0.194, y: 0.1322)),
                .init(type: .box2, position: .init(x: 0.2922, y: 0.126)),
                .init(type: .tree4, position: .init(x: 0.15, y: 0.52)),
                .init(type: .tree5, position: .init(x: 0.654, y: 0.9))
            ]
        case "13":
            [
                .init(type: .tree8, position: .init(x: 0.2, y: 0.1921234)),
                .init(type: .tree10, position: .init(x: 0.7, y: 0.23242)),
                .init(type: .helicopter, position: .init(x: 0.4, y: 0.3)),
                .init(type: .tree6, position: .init(x: 0.29, y: 0.4)),
                .init(type: .tree2, position: .init(x: 0.1, y: 0.8)),
                .init(type: .tree4, position: .init(x: 0.5, y: 0.82123)),
                .init(type: .tree6, position: .init(x: 0.76, y: 0.79342)),
                .init(type: .oil, position: .init(x: 0.6, y: 0.43))
            ]
        case "14":
            [
                .init(type: .tree6, position: .init(x: 0.18, y: 0.73424)),
                .init(type: .tree6, position: .init(x: 0.23, y: 0.6934489)),
                .init(type: .tree8, position: .init(x: 0.8, y: 0.4)),
                .init(type: .tree9, position: .init(x: 0.6, y: 0.2)),
                .init(type: .tree5, position: .init(x: 0.3, y: 0.2)),
                
            ]
        case "15":
            [
                .init(type: .helicopter, position: .init(x: 0.5, y: 0.63)),
                .init(type: .tree6, position: .init(x: 0.35, y: 0.65)),
                .init(type: .oil, position: .init(x: 0.85, y: 0.34)),
                .init(type: .tree8, position: .init(x: 0.8, y: 0.5)),
                .init(type: .tree6, position: .init(x: 0.16, y: 0.3)),
                .init(type: .tree4, position: .init(x: 0.19, y: 0.4)),
                .init(type: .tree6, position: .init(x: 0.19, y: 0.25))
            ]
        case "16":
            [
                .init(type: .tree8, position: .init(x: 0.2, y: 0.3)),
                .init(type: .tree6, position: .init(x: 0.3, y: 0.41)),
                .init(type: .helicopter, position: .init(x: 0.8, y: 0.9)),
                .init(type: .tree4, position: .init(x: 0.5, y: 0.2)),
                .init(type: .tree4, position: .init(x: 0.31, y: 0.23))
            ]
        case "17":
            [
                .init(type: .tree4, position: .init(x: 0.25, y: 0.66)),
                .init(type: .tree6, position: .init(x: 0.15, y: 0.8)),
                .init(type: .tree4, position: .init(x: 0.13, y: 0.7)),
                .init(type: .tree6, position: .init(x: 0.21, y: 0.78)),
                .init(type: .helicopter, position: .init(x: 0.6, y: 0.24)),
                .init(type: .tree8, position: .init(x: 0.81, y: 0.2)),
                .init(type: .tree4, position: .init(x: 0.68, y: 0.7)),
            ]
        case "18":
            [
                .init(type: .rock1, position: .init(x: 0.15, y: 0.4)),
                .init(type: .tree6, position: .init(x: 0.4, y: 0.4)),
                .init(type: .tree8, position: .init(x: 0.55, y: 0.48))
            ]
        case "19":
            [
                .init(type: .rock2, position: .init(x: 0.86, y: 0.45)),
                .init(type: .tree8, position: .init(x: 0.19, y: 0.73)),
                .init(type: .helicopter, position: .init(x: 0.7, y: 0.4)),
                .init(type: .tree4, position: .init(x: 0.68, y: 0.69)),
                .init(type: .tree9, position: .init(x: 0.8, y: 0.6)),
                .init(type: .tree7, position: .init(x: 0.5, y: 0.23))
            ]
        case "20":
            [
                .init(type: .house2, position: .init(x: 0.2, y: 0.65)),
                .init(type: .tree2, position: .init(x: 0.5, y: 0.54)),
                .init(type: .tree6, position: .init(x: 0.34, y: 0.7)),
                .init(type: .tree8, position: .init(x: 0.47, y: 0.74)),
                .init(type: .tree6, position: .init(x: 0.15, y: 0.4)),
                .init(type: .tree6, position: .init(x: 0.33, y: 0.6)),
                .init(type: .tree2, position: .init(x: 0.85, y: 0.8)),

            ]
        case "21":
            [
                .init(type: .tree5, position: .init(x: 0.15, y: 0.43)),
                .init(type: .helicopter, position: .init(x: 0.45, y: 0.75)),
                .init(type: .tree6, position: .init(x: 0.5, y: 0.6)),
                .init(type: .tree6, position: .init(x: 0.43, y: 0.57)),
                .init(type: .tree6, position: .init(x: 0.57, y: 0.7)),
                .init(type: .tree4, position: .init(x: 0.74, y: 0.52)),
                .init(type: .tree6, position: .init(x: 0.58, y: 0.465))
            ]
        default: [
//            .init(type: .tree6, position: .init(x: 0.2, y: 0.76)),
//            .init(type: .tree10, position: .init(x: 0.5, y: 0.55))
        ]
        }
        //house, treese > 5 - multipliwers
    }
}
