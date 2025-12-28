//
//  BuyCoinsCell.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 17.12.2025.
//

import UIKit

class BuyCoinsCell: UICollectionViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    func set(_ amount: String) {
        titleLabel.text = amount
    }
}
