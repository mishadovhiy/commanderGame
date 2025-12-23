//
//  AlertTitleTableCell.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 23.12.2025.
//

import UIKit

class AlertTitleTableCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    func set(data: AlertModel.TitleCellModel) {
        titleLabel.text = data.title
    }

}
