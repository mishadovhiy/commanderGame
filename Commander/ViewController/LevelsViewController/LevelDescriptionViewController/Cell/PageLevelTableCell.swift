//
//  PageLevelTableCell.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 25.12.2025.
//

import UIKit

class PageLevelTableCell: UITableViewCell {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var startingMoneyLabel: UILabel!
    @IBOutlet weak var rangesLabel: UILabel!
    @IBOutlet weak var livesLabel: UILabel!
    @IBOutlet private weak var pageLabel: UILabel!
    
    func set() {
        pageLabel.attributedText = .init(string: "")
    }
}
