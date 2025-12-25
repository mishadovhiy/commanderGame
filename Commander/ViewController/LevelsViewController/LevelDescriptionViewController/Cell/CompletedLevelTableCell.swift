//
//  SelectedLevelTableCell.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 24.12.2025.
//

import UIKit

class CompletedLevelTableCell: UITableViewCell {

    
    @IBOutlet private weak var rightTitleLabel: UILabel!
    
    @IBOutlet private weak var contentStackView: UIStackView!
    @IBOutlet private weak var sectionNameLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        contentStackView.addSubview(ContainerMaskedView(isHorizontal: nil))
    }
    
    func set(data: ContentDataModel) {
        loadViewsIfNeeded(for: data.data.tableData.count)
        sectionNameLabel.text = data.section
        var sectionI: Int = 0
        data.data.tableData.forEach { model in
            sectionI += 1
            var i = 0
            [model.content.left, model.content.middle, model.content.right].forEach { data in
                self.setValue(for: .init(row: i, section: sectionI), value: data, section: model.section)
                i += 1

            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentStackView.arrangedSubviews.forEach {
            if $0.tag != 0 {
                $0.isHidden = true
            }
        }
    }
}

extension CompletedLevelTableCell {
    struct ContentDataModel {
        let section: String
        let data: CellTableModel
    }
    struct CellTableModel {
        let topTitles: HStackModel
        let tableData: [
            TableDataModel
        ]
        
        struct TableDataModel {
            let section: LeftSectionModel
            let content: HStackModel
        }
        
        struct LeftSectionModel {
            let title: String
            let leftSubtitle: String?
            init(_ title: String, leftSubtitle: String? = nil) {
                self.title = title
                self.leftSubtitle = leftSubtitle
            }
        }
        struct HStackModel {
            let left: ValueModel
            let middle: ValueModel
            let right: ValueModel
            
            struct ValueModel {
                let text: String
                let progress: Float?
                
                init(_ text: String, progress: Float? = nil) {
                    self.text = text
                    self.progress = progress
                }
            }
        }
    }
}

fileprivate
extension CompletedLevelTableCell {
    func setValue(for indexPath: IndexPath,
                  value: CellTableModel.HStackModel.ValueModel,
                  section: CellTableModel.LeftSectionModel
    ) {
        let views = getRowViews(for: indexPath)
        
        views.label?.text = value.text
        views.progress?.progress = value.progress ?? 0
        
        views.titleLabel?.text = section.title
        views.subtitleLabel?.text = section.leftSubtitle
        
        if (views.subtitleLabel?.isHidden ?? true) != (views.subtitleLabel?.text?.isEmpty ?? true) {
            views.subtitleLabel?.isHidden = views.subtitleLabel?.text?.isEmpty ?? true
        }
        
        if (views.progress?.isHidden ?? true) != (value.progress == nil) {
            views.progress?.isHidden = value.progress == nil
        }
    }
    
    private func getRowViews(for indexPath: IndexPath) -> (
        label: UILabel?,
        progress: UIProgressView?,
        titleLabel: UILabel?,
        subtitleLabel: UILabel?)
    {
        let rowSuperviewStack = (contentStackView.arrangedSubviews.first(where: {
            $0.tag == (indexPath.section)
        }) as? UIStackView)
        let contentStack = rowSuperviewStack?.arrangedSubviews.first(where: {
            $0.layer.name == "rowContent"
        }) as? UIStackView
        rowSuperviewStack?.isHidden = false
        let titleStack = rowSuperviewStack?.arrangedSubviews.first(where: {
            $0.layer.name != "rowContent"
        }) as? UIStackView
        let stack = contentStack?.arrangedSubviews.first(where: {
            $0.tag == indexPath.row
        }) as? UIStackView
        
        let titleLabel = titleStack?.arrangedSubviews.first(where: {
            $0.tag == 0
        }) as? UILabel
        let subtitleLabel = titleStack?.arrangedSubviews.first(where: {
            $0.tag == 1
        }) as? UILabel
        
        let label = stack?.arrangedSubviews.first(where: {
            $0 is UILabel
        }) as? UILabel
        
        let progress = stack?.arrangedSubviews.first(where: {
            $0 is UIProgressView
        }) as? UIProgressView
        return (label, progress, titleLabel, subtitleLabel)
    }
    
    func loadViewsIfNeeded(for dataCount: Int) {
        let difference = (dataCount + 1) - contentStackView.arrangedSubviews.count
        if difference <= 0 {
            return
        }
        Array(0..<difference).forEach { _ in
            loadRowCell()
        }
    }
    
    func loadRowCell() {
        let hstack = UIStackView()
        hstack.distribution = .fillProportionally
        hstack.alignment = .fill
        hstack.axis = .horizontal
        hstack.tag = self.contentStackView.arrangedSubviews.count
        let leftTitleStack = loadLeftTitleStack()
        hstack.addArrangedSubview(leftTitleStack)
        leftTitleStack.translatesAutoresizingMaskIntoConstraints = false
//        leftTitleStack.widthAnchor.constraint(equalTo: rightTitleLabel.widthAnchor).isActive = true
        leftTitleStack.widthAnchor.constraint(equalToConstant: 30).isActive = true
        hstack.addArrangedSubview(loadRowContentStack())
        
        contentStackView.addArrangedSubview(hstack)
    }
    
    func loadRowContentStack() -> UIStackView {
        let hstack = UIStackView()
        hstack.layer.name = "rowContent"
        hstack.axis = .horizontal
        hstack.distribution = .fillEqually
        Array(0..<3).forEach {
            hstack.addArrangedSubview(loadValueTitle(i: $0))
        }
        return hstack
    }
    
    func loadValueTitle(i: Int) -> UIStackView {
        let vstack = UIStackView()
        vstack.axis = .vertical
        vstack.tag = i
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 10)
        label.minimumScaleFactor = 0.2
        
        let progress = UIProgressView()
        [label, progress].forEach {
            vstack.addArrangedSubview($0)
        }
        return vstack
    }
    
    func loadLeftTitleStack() -> UIStackView {
        let vstack = UIStackView()
        vstack.axis = .vertical
        
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 10)
        titleLabel.textColor = .accent
        titleLabel.text = "title"
        titleLabel.tag = 0
        let subtitleLabel = UILabel()
        subtitleLabel.font = .systemFont(ofSize: 10)
        subtitleLabel.textColor = .white.withAlphaComponent(0.4)
        subtitleLabel.text = "subtitle"
        subtitleLabel.tag = 1
        [titleLabel, subtitleLabel].forEach {
            vstack.addArrangedSubview($0)
        }
        return vstack
    }
}
