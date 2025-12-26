//
//  PageLevelTableCell.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 25.12.2025.
//

import UIKit

class PageLevelTableCell: UITableViewCell {

    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var progressLabel: UILabel!
    @IBOutlet private weak var startingMoneyLabel: UILabel!
    @IBOutlet private weak var rangesLabel: UILabel!
    @IBOutlet private weak var livesLabel: UILabel!
    @IBOutlet private weak var pageLabel: UILabel!
    @IBOutlet private weak var levelLabel: UILabel!
    
    func set(data: ContentDataModel) {
        let pageTitle = NSMutableAttributedString(string: data.pageModel.levelPage)

        let levelTitle = NSMutableAttributedString(string: data.pageModel.level)
        let attributedComponents = [
            pageTitle: "continent",
            levelTitle: "Lvl"
        ]
        attributedComponents.forEach {
            $0.key.append(.init(string: $0.value, attributes: [
                .font: UIFont.systemFont(ofSize: 10),
                .foregroundColor: UIColor.white.withAlphaComponent(0.4)
            ]))
        }
        levelLabel.attributedText = levelTitle
        pageLabel.attributedText = pageTitle
        
        progressView.progress = data.progress
        progressLabel.text = "\(Int(data.progress * 100))"
        livesLabel.text = "\(data.builder?.health ?? 0)"
        rangesLabel.text = "\(data.builder?.rounds ?? 0)"
        startingMoneyLabel.text = "\(data.builder?.startingMoney ?? 0)"
    }
}

extension PageLevelTableCell {
    struct ContentDataModel {
        let pageModel: LevelModel
        let builder: GameBuilderMiniModel?
        let totalLevelCount: Int
        let completedLevelCount: Int
        var progress: Float {
            .init(completedLevelCount / totalLevelCount)
        }
    }
    
}
