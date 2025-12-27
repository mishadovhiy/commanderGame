//
//  HomeViewController.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 19.12.2025.
//

import UIKit

class HomeViewController: AudioViewController {

    @IBOutlet private weak var mapImageView: UIImageView!
    @IBOutlet private weak var contentStackView: UIStackView!
    @IBOutlet private weak var startView: UIView!
    private var levelAnimating: Bool = false
    var currentPage: LevelPagesBuilder?
    override var audioFiles: [AudioFileNameType] {
        AudioFileNameType.allCases.filter({$0.type == .menu})
    }
    override func loadView() {
        super.loadView()
        self.mapImageView.translatesAutoresizingMaskIntoConstraints = true
        mapImageView.layer.shadowColor = UIColor.black.cgColor
        mapImageView.layer.shadowOpacity = 0.5
        mapImageView.layer.shadowRadius = 10
        loadLevelListChild()
        self.view.addSubview(DestinationOutMaskedView(type: .borders))
        blackSafeAreaMaskOverlayView?.alpha = 0
    }
    
    var blackSafeAreaMaskOverlayView: UIView? {
        self.view.subviews.first(where: {
            $0.layer.name?.contains(String.init(describing: DestinationOutMaskedView.self)) ?? false
        })
    }
    
    public func setMap(for page: LevelPagesBuilder?, animated: Bool = true,
                       completion:@escaping()->() = {}) {
        if page != nil {
            self.currentPage = page
        }
        if levelAnimating {
            return
        }
        let page = self.startView.isHidden ? page : nil
        self.levelAnimating = true

        self.performSetMap(for: page, animated: animated, completion: {
            completion()
            self.levelAnimating = false
        })
        
    }
    
    private func performSetMap(for page: LevelPagesBuilder?,
                               animated: Bool,
                               completion:@escaping()->() = {}) {
        let viewSize = view.frame.size
        let imageSize: CGSize = self.mapImageView.image?.size ?? .zero
        UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
            self.view.backgroundColor = page == nil ? .dark : .container
            self.view.tintColor = page == nil ? .accent : .white
            let multiplier = page?.zoom ?? 1
            let size: CGSize = page == nil ? viewSize : imageSize
            let resultSize: CGSize = .init(width: size.width * multiplier, height: size.height * multiplier)
            let origin: CGPoint = .init(
                x: (page?.mapPosition.x ?? 0) * resultSize.width,
                y: (page?.mapPosition.y ?? 0) * resultSize.height)
            let frame: CGRect = .init(origin: origin,
                                      size: resultSize)
            self.mapImageView.frame = frame
        }, completion: {_ in
            completion()
        })
    }
    
    public func setStartPressed(_ startPressed: Bool) {
        self.play(.menu1)
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
        play(.menu1)
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
