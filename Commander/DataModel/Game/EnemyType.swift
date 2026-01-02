//
//  EnemyType.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 11.12.2025.
//

import Foundation
import UIKit

enum EnemyType: String, CaseIterable {
    case soldeir
    case flight
    case militaryFlightSimple
    case mulutaryFlightComplex
    case helicopterFlight
    case tankLight
    case tankHeavy
    case tankMedium
    case tankMBT
    case vehicle
    case fastVehicle
    case armouredVehicle
    case flightVehicle
    
    var component: Component {
        return Component.allCases.first(where: {
            self.rawValue.lowercased().contains($0.rawValue)
        })!
    }
    
    var assetAnimations: AssetAnimation {
        switch component {
        case .soldeir:
                .init(run: 7, die: 5, damaged: 0)
        case .flight:
                .init(run: 1, die: 0, damaged: 1)
        case .tank:
                .init(run: 1, die: 0, damaged: 2)
        case .vehicle:
                .init(run: 1, die: 0, damaged: 4)
        }
    }
    
    struct AssetAnimation {
        /// maximum number of assets during run
        let run: Int
        let die: Int
        let damaged: Int
    }
    
    enum Component: String, CaseIterable {
        case soldeir
        case flight
        case tank
        case vehicle
    }
    
    var speed: Int {
        switch self {
        case .soldeir:
            15
        case .flight:
            13
        case .militaryFlightSimple:
            8
        case .mulutaryFlightComplex:
            6
        case .helicopterFlight:
            15
        case .tankLight:
            4
        case .tankHeavy:
            2
        case .tankMedium:
            3
        case .tankMBT:
            5
        case .vehicle:
            7
        case .fastVehicle:
            25
        case .armouredVehicle:
            10
        case .flightVehicle:
            5
        }
    }
    
    var health: Int {
        switch self {
        case .soldeir:
            1
        case .flight:
            7
        case .militaryFlightSimple:
            10
        case .mulutaryFlightComplex:
            25
        case .helicopterFlight:
            15
        case .tankLight:
            25
        case .tankHeavy:
            50
        case .tankMedium:
            40
        case .tankMBT:
            80
        case .vehicle:
            7
        case .fastVehicle:
            5
        case .armouredVehicle:
            20
        case .flightVehicle:
            30
        }
    }
}
