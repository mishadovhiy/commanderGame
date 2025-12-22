//
//  WeaponBuyCell.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 14.12.2025.
//

import UIKit

class WeaponBuyCell: UITableViewCell {
    
    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private weak var buyButtonTitle: UILabel!
    @IBOutlet weak var containerCell: UIView!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var levelLabel: UILabel!
    @IBOutlet private weak var upgradePriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.addSubview(ContainerMaskedView(isHorizontal: true, type: .signle))
        contentView.backgroundColor = ContainerMaskedView.Constants.largeBorderColor
        containerCell.layer.borderColor = ContainerMaskedView.Constants.borderColor.cgColor
        containerCell.layer.borderWidth = 2
        containerCell.backgroundColor = ContainerMaskedView.Constants.secondaryBorderColor
        buyButtonTitle.transform = CGAffineTransform(rotationAngle: CGFloat.pi / -2)
    }
    
    func set(
        _ dataModel: UpgradeWeaponViewController.WeaponBuyModel) {
            buyButton.layer.name = dataModel.type.rawValue
            progressView.progress = dataModel.percent
            titleLabel.text = dataModel.type.rawValue
            upgradePriceLabel.text = "\(dataModel.price)"
            levelLabel.text = "\(dataModel.level)"
            iconView.image = .init(named: dataModel.type.iconName)
            iconView.tintColor = .init(hex: "A88934")
    }
}
