//
//  HomeViewController.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 19.12.2025.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet private weak var contentStackView: UIStackView!
    @IBOutlet private weak var startView: UIView!
    
    var blackSafeAreaMaskOverlayView: UIView? {
        self.view.subviews.first(where: {
            $0.layer.name?.contains(String.init(describing: DestinationOutMaskedView.self)) ?? false
        })
    }
    
    override func loadView() {
        super.loadView()
        loadLevelListChild()
        self.view.addSubview(DestinationOutMaskedView(type: .borders))
        blackSafeAreaMaskOverlayView?.alpha = 0
    }
    
    public func setStartPressed(_ startPressed: Bool) {
        let vc = children.first(where: {
            $0 is LevelListSuperViewController
        })
        UIView.animate(withDuration: 0.3, animations: {
            vc?.view.isHidden = !startPressed
            self.startView.isHidden = startPressed
            self.blackSafeAreaMaskOverlayView?.alpha = startPressed ? 1 : 0
        }, completion: { _ in
            
        })
    }
    
    @IBAction private func startDidPress(_ sender: Any) {
        setStartPressed(true)
    }
}

fileprivate
extension HomeViewController {
    func loadLevelListChild() {
        let vc = LevelListSuperViewController.initiateDefault()
        vc.view.isHidden = true
        contentStackView.addArrangedSubview(vc.view)
        vc.didMove(toParent: self)
        addChild(vc)
    }
}
