//
//  LevelListSuperView.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 13.12.2025.
//

import UIKit

class LevelListSuperViewController: UIViewController {
    
    @IBOutlet weak var bottomPanelStackView: UIStackView!
    @IBOutlet weak private var pageContainerView: UIView!
    
    override func loadView() {
        super.loadView()
        bottomPanelStackView.isHidden = true
        loadUI()
    }
    
    var selectedLevel: LevelModel? {
        didSet {
            UIView.animate(withDuration: 0.3, animations: {
                self.bottomPanelStackView?.isHidden = self.selectedLevel == nil

            }, completion: { _ in
            })
        }
    }
}

extension LevelListSuperViewController {
    func loadUI() {
        loadChild()
    }
    
    func loadChild() {
        let childVC = LevelsPageViewController.initiate()
        pageContainerView.addSubview(childVC.view)
        childVC.view
            .translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            childVC.view.leadingAnchor.constraint(
                equalTo: childVC.view.superview!.leadingAnchor),
            childVC.view.trailingAnchor.constraint(
                equalTo: childVC.view.superview!.trailingAnchor),
            childVC.view.topAnchor.constraint(
                equalTo: childVC.view.superview!.topAnchor),
            childVC.view.bottomAnchor.constraint(
                equalTo: childVC.view.superview!.bottomAnchor)
        ])
        addChild(childVC)
        childVC.didMove(toParent: self)
    }
}
