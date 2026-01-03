//
//  AlertTitleCollectionCell.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 23.12.2025.
//

import UIKit

class AlertTitleCollectionCell: UICollectionViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.addDarkOverlay()
        contentView.insertSubview(ContainerMaskedView(isHorizontal: nil), at: 0)
        titleLabel.textAlignment = .center
    }
    
    func set(data: AlertModel.TitleCellModel) {
        titleLabel.textColor = data.button?.didPress == nil && data.button?.toAlert == nil ? .dark : .dark
        titleLabel.font = data.isSmallText ? .systemFont(ofSize: 12, weight: .medium) : .systemFont(ofSize: 15, weight: .semibold).customFont()

        if let text = data.attributedString {
            titleLabel.text = nil
            titleLabel.attributedText = text

        } else {
            titleLabel.attributedText = nil
            titleLabel.text = data.title
        }
        self.backgroundColor = data.button?.didPress == nil && data.button?.toAlert == nil ? .clear : .white.withAlphaComponent(0.35)
    }
}
