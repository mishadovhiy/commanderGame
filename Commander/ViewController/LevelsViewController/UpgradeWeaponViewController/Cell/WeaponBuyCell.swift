//
//  WeaponBuyCell.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 14.12.2025.
//

import UIKit

class WeaponBuyCell: UITableViewCell {
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var increesePercentLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var upgradePriceLabel: UILabel!
    
    func set(
        _ dataModel: UpgradeWeaponViewController.WeaponBuyModel,
        buyDidPress: @escaping()->()) {
        
    }
    
    @IBAction func buyDidPress(_ sender: Any) {
    }
    
    
}
