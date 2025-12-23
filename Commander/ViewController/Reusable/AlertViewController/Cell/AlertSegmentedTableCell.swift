//
//  AlertSegmentedTableCell.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 23.12.2025.
//

import UIKit

class AlertSegmentedTableCell: UITableViewCell {

    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var segmentedView: UISlider!
    
    func set(data: AlertModel.SegmentedCellModel) {
        valueLabel.text = "\(data.segmentValue * 100)"
        titleLabel.text = data.title
    }

}
