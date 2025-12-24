//
//  HomeViewController.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 19.12.2025.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet private weak var mapImageView: UIImageView!
    @IBOutlet private weak var contentStackView: UIStackView!
    @IBOutlet private weak var startView: UIView!
    
    var blackSafeAreaMaskOverlayView: UIView? {
        self.view.subviews.first(where: {
            $0.layer.name?.contains(String.init(describing: DestinationOutMaskedView.self)) ?? false
        })
    }
    
    override func loadView() {
        super.loadView()
        mapImageView.translatesAutoresizingMaskIntoConstraints = false
        loadLevelListChild()
        self.view.addSubview(DestinationOutMaskedView(type: .borders))
        blackSafeAreaMaskOverlayView?.alpha = 0
    }
    private var levelAnimating: Bool = false
    var currentPage: LevelPagesBuilder?
    public func setMap(for page: LevelPagesBuilder?, animated: Bool = true,
                       completion:@escaping()->() = {}) {
        if page != nil {
            self.currentPage = page
        }
        if levelAnimating {
            return
        }
        let page = self.startView.isHidden ? page : nil
        print(page?.zoom, " hfgdfsfgd", page?.title, " yhtgrf", mapImageView.frame.origin)
        self.levelAnimating = true

        if mapImageView.frame.origin != .zero,
            page != nil,
            animated {
            self.performSetMap(for: nil, animated: animated, completion: {
                self.performSetMap(for: page, animated: animated, completion: {
                    completion()
                    self.levelAnimating = false
                })
            })
        } else {
            self.performSetMap(for: page, animated: animated, completion: {
                completion()
                self.levelAnimating = false
            })
        }
        
    }
    
    private func performSetMap(for page: LevelPagesBuilder?,
                               animated: Bool,
                               completion:@escaping()->() = {}) {
        let viewSize = view.frame.size
        UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
            self.view.backgroundColor = page == nil ? .dark : .container
            self.view.tintColor = page == nil ? .accent : .white
            self.mapImageView.transform = CGAffineTransform(scaleX: page?.zoom ?? 1, y: page?.zoom ?? 1)
            self.mapImageView.frame.origin.x = (page?.mapPosition.x ?? 0) * viewSize.width
            self.mapImageView.frame.origin.y = (page?.mapPosition.y ?? 0) * viewSize.height

        }, completion: {_ in
            completion()
        })
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
            self.setMap(for: self.currentPage ?? [LevelPagesBuilder].allData.first)
        })
    }
    
    @IBAction func settingsDidPress(_ sender: Any) {
        UIApplication.shared.activeWindow?.rootViewController?.present(vc: AlertViewController.initiate(
            data: .settings)
        )
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
