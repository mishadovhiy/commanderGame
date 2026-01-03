//
//  AlertLevelProgressCell.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 03.01.2026.
//

import UIKit

class AlertLevelProgressCell: UICollectionViewCell {
    @IBOutlet private weak var levelLabel: UILabel!
    
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var difficultyLabel: UILabel!
    @IBOutlet private weak var pageLabel: UILabel!
    
    func set(_ data: AlertModel.LevelProgressModel) {
        levelLabel.text = data.level.level
        pageLabel.text = data.level.levelPage
        typeLabel.text = data.level.duration?.rawValue
        difficultyLabel.text = data.level.difficulty?.rawValue
    }
}
