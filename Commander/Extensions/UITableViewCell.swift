//
//  UITableViewCell.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 07.01.2026.
//

import UIKit

extension UITableViewCell {
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.selectedBackgroundView = .init()
    }
}

extension UICollectionViewCell {
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.selectedBackgroundView = .init()
    }
}
