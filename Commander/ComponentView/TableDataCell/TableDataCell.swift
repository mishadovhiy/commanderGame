//
//  TableDataCell.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 14.12.2025.
//

import UIKit

class TableDataCell: UITableViewCell {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectedBackgroundView = .init()
        backgroundColor = .init(hex: "2C2615")
        contentView.addSubview(ContainerMaskedView(isHorizontal: true))
    }
    
    func set(_ data: TableDataModel) {
        if let imageName = data.icon,
           let image = UIImage(named: imageName)
        {
            iconImageView.image = image
        }
//        switch data.higlighted {
//        case .distributed:
//            backgroundColor = .red
//        case .accent:
//            backgroundColor = UIColor.blue
//        default:
//            backgroundColor = UIColor.clear
//        }
        nameLabel.text = data.title
        descriptionLabel.text = data.text
        
        nameLabel.isHidden = nameLabel.text?.isEmpty ?? true
        descriptionLabel.isHidden = descriptionLabel.text?.isEmpty ?? true
        iconImageView.isHidden = iconImageView.image == nil

    }
}
