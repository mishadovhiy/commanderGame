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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        segmentedView.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
    }
    
    @objc private func sliderChanged(_ sender: UISlider) {
        valueLabel.text = "\(sender.value * 100)"
    }
    
    func set(data: AlertModel.SegmentedCellModel) {
        titleLabel.text = data.title
        segmentedView.value = Float(data.segmentValue)
        sliderChanged(segmentedView)
    }

}
