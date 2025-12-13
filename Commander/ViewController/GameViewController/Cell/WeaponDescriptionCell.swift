//
//  WeaponDescriptionCell.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 13.12.2025.
//

import UIKit

class WeaponDescriptionCell: UITableViewCell {
    ///total upgrade level
    ///upgrade difficult name
    ///item name
    ///weapon description, usage
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    func set(_ data: GameViewController.WeaponTableData) {
        if let imageName = data.icon,
           let image = UIImage(named: imageName)
        {
            iconImageView.image = image
        }
        nameLabel.text = data.title
        descriptionLabel.text = data.text
        
        nameLabel.isHidden = nameLabel.text?.isEmpty ?? true
        descriptionLabel.isHidden = descriptionLabel.text?.isEmpty ?? true
        iconImageView.isHidden = iconImageView.image == nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectedBackgroundView = .init()
    }
}
