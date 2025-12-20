//
//  WeaponBuyCell.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 14.12.2025.
//

import UIKit

class WeaponBuyCell: UITableViewCell {
    
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var increesePercentLabel: UILabel!
    @IBOutlet private weak var levelLabel: UILabel!
    @IBOutlet private weak var upgradePriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.addSubview(ContainerMaskedView(isHorizontal: true))
    }
    
    func set(
        _ dataModel: UpgradeWeaponViewController.WeaponBuyModel) {
            buyButton.layer.name = dataModel.type.rawValue
            progressView.progress = dataModel.percent
            titleLabel.text = dataModel.type.rawValue
            upgradePriceLabel.text = "\(dataModel.price)"
            levelLabel.text = "\(dataModel.level)"
            increesePercentLabel.text = "\(dataModel.increesePercent)"
    }
}
