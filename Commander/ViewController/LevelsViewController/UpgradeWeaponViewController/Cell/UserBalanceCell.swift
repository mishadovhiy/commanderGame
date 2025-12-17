//
//  UserBalanceCell.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 14.12.2025.
//

import UIKit

class UserBalanceCell: UITableViewCell {
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet private weak var balanceLabel: UILabel!
    
    func set(_ balance: Float) {
        balanceLabel.text = .init(format: "%.2f", balance)
    }
}
