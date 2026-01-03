//
//  PageLevelTableCell.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 25.12.2025.
//

import UIKit

class PageLevelTableCell: UITableViewCell {

    @IBOutlet private weak var prizeLabel: UILabel!
    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var progressLabel: UILabel!
    @IBOutlet private weak var startingMoneyLabel: UILabel!
    @IBOutlet private weak var rangesLabel: UILabel!
    @IBOutlet private weak var livesLabel: UILabel!
    @IBOutlet private weak var pageLabel: UILabel!
    @IBOutlet private weak var levelLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.addSubview(ContainerMaskedView(isHorizontal: nil))
    }
    
    func set(data: ContentDataModel) {
        let pageTitle = NSMutableAttributedString(string: data.levelTitle)

        let levelTitle = NSMutableAttributedString(string: data.pageModel.level)
        let attributedComponents = [
            pageTitle: " continent",
            levelTitle: " Lvl"
        ]
        attributedComponents.forEach {
            $0.key.append(.init(string: $0.value, attributes: [
                .font: UIFont.systemFont(ofSize: 10),
                .foregroundColor: UIColor.white.withAlphaComponent(0.4)
            ]))
        }
        prizeLabel.text = "\(data.builder?.prize ?? 0)"
        levelLabel.attributedText = levelTitle
        levelLabel.numberOfLines = 0
        levelLabel.isHidden = data.pageModel.level.isEmpty
        pageLabel.attributedText = pageTitle
        pageLabel.textAlignment = data.pageModel.level.isEmpty ? .left : .right
        progressView.progress = data.progress
        let progressText: NSMutableAttributedString = .init(string: " \(Int(data.progress * 100))%")
        progressText.insert(.init(string: "\(data.completedLevelCount)/\(data.totalLevelCount)" + " ", attributes: [
            .font: UIFont.systemFont(ofSize: 9, weight: .semibold),
            .foregroundColor: UIColor.white.withAlphaComponent(0.15).cgColor
        ]), at: 0)
        progressLabel.attributedText = progressText
        livesLabel.text = "\(data.builder?.health ?? 0)"
        rangesLabel.text = "\(data.builder?.rounds ?? 0)"
        startingMoneyLabel.text = "\(data.builder?.startingMoney ?? 0)"
        livesLabel.superview?.superview?.isHidden = data.builder == nil
        progressView.superview?.isHidden = data.builder != nil
    }
}

extension PageLevelTableCell {
    struct ContentDataModel {
        let pageModel: LevelModel
        let builder: GameBuilderMiniModel?
        let levelTitle: String
        let totalLevelCount: Int
        let completedLevelCount: Int
        var progress: Float {
            Float(completedLevelCount) / Float(totalLevelCount)
        }
    }
    
}
