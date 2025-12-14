//
//  WeaponTypeCell.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 14.12.2025.
//

import UIKit

class WeaponTypeCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    func set(_ data: UpgradeWeaponViewController.WeaponTypeModel) {
        titleLabel.text = data.title
    }
}
