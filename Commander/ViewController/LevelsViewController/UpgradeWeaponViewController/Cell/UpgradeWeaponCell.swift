//
//  UpgradeWeaponCell.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 14.12.2025.
//

import UIKit

class UpgradeWeaponCell: UICollectionViewCell {
    @IBOutlet private weak var weaponImageView: UIImageView!
    
    func set(_ type: WeaponType) {
        weaponImageView.image = .init(named: type.rawValue)
         
    }
}
