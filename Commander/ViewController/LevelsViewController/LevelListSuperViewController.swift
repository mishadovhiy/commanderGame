//
//  LevelListSuperView.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 13.12.2025.
//

import UIKit

class LevelListSuperViewController: UIViewController {
    
    @IBOutlet private weak var bottomBarConstraint: NSLayoutConstraint!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var rightPanelStackView: UIStackView!
    @IBOutlet private weak var upgradeButton: UIButton!
    @IBOutlet private weak var bottomPanelStackView: UIStackView!
    @IBOutlet private weak var pageContainerView: UIView!
    
    override func loadView() {
        super.loadView()
        loadUI()
    }
        
    var rightPanelNavigation: UINavigationController? {
        children.first(where: {
            $0 is UINavigationController && $0.view?.layer.name == Constants.Names.rightPanelNavigation.rawValue
        }) as? UINavigationController
    }
    
    var bottomPanelNavigation: UINavigationController? {
        children.first(where: {
            $0 is UINavigationController && $0.view?.layer.name == Constants.Names.bottomPanelNavigation.rawValue
        }) as? UINavigationController
    }
    
    var levelDescriptionVC: LevelDescriptionViewController? {
        rightPanelNavigation?.viewControllers.first(where: {
            $0 is LevelDescriptionViewController
        }) as? LevelDescriptionViewController
    }
    
    var levelPageVC: LevelsPageViewController? {
        children.first(where: {
            $0 is LevelsPageViewController
        }) as? LevelsPageViewController
    }
    
    var homeParentVC: HomeViewController? {
        parent as? HomeViewController
    }
    
    var selectedLevel: LevelModel = .init(level: "", levelPage: "1") {
        didSet {
            let hide = self.selectedLevel.level.isEmpty
            let hideStart = selectedLevel.hasEmptyValue
            levelDescriptionVC?.selectedLevelUpdated()
            if selectedLevel.duration == nil && self.bottomPanelNavigation?.viewControllers.count != 1 {
                bottomPanelNavigation?.popToRootViewController(animated: true)
            }
            if selectedLevel.difficulty == nil {
                (bottomPanelNavigation?.viewControllers.first as? DifficultyViewController)?.selectedAt = nil
            }
            updateBottomNavigationDifficulties(animated: true)
            UIView.animate(withDuration: 0.3, animations: {
                if hide != self.bottomPanelStackView?.isHidden {
                    self.bottomPanelStackView?.isHidden = hide
                }
                if self.startButton.isHidden != hideStart {
                    self.startButton.isHidden = hideStart
                }
            }, completion: { _ in
                self.homeParentVC?.setMap(for: self.homeParentVC?.currentPage, animated: false)
            })
        }
    }
    
    @IBAction private func startGameDidPress(_ sender: Any) {
        homeParentVC?.play(.success1)
        let vc = GameViewController.initiate(self.selectedLevel, page: levelPageVC!.currentPageData)
        vc.didDismiss = { [weak self] in
            self?.levelPageVC?.viewControllers?.forEach {
                ($0 as? LevelViewController)?.setCompletedLevels()
            }
        }
        self.present(vc, animated: true)
    }
    
    @IBAction private func upgradeDidPress(_ sender: UIButton) {
        homeParentVC?.play(.menu2)
        rightPanelNavigation?.pushViewController(UpgradeWeaponViewController.initiateDefault(), animated: true)
    }
    
    @IBAction private func backDidiPress(_ sender: Any) {
        homeParentVC?.play(.menu1)
        homeParentVC?.setStartPressed(false)
    }
    
    func toGameDurationPicker() {
        homeParentVC?.play(.menu1)
        DispatchQueue(label: "db", qos: .userInitiated).async {
            let db = DataBaseService.db.completedLevels
            let completedKeys = db.keys.filter({
                ![
                    $0.levelPage == self.selectedLevel.levelPage,
                    $0.level == self.selectedLevel.level,
                    $0.difficulty == self.selectedLevel.difficulty
                ].contains(false)
            })
            DispatchQueue.main.async {
                self.bottomPanelNavigation?.pushViewController(
                    DifficultyViewController.initiate(data: GameDurationType.allCases.compactMap({ duration in
                        let contains = completedKeys.contains(where: {
                            $0.duration == duration
                        })
                        return .init(title: duration.rawValue, checkmarkCount: contains ? 1 : 0)
                    }), didSelect: { value in
                        self.selectedLevel.duration = .init(rawValue: value)
                    }), animated: true)
            }
        }
    }
}

extension LevelListSuperViewController: UINavigationControllerDelegate {
    private
    func rightNavigationChanged(viewControllerCount: Int) {
        if viewControllerCount == 1 {
            let value = self.selectedLevel
            self.selectedLevel = value
            
        }
        let hide = viewControllerCount > 1
        UIView.animate(withDuration: 0.3) {
            if viewControllerCount != 1 {
                if self.bottomPanelStackView.isHidden != hide {
                    self.bottomPanelStackView.isHidden = hide
                }
                if self.startButton.isHidden != hide {
                    self.startButton.isHidden = hide
                }
            }
            if self.pageContainerView.isHidden != hide {
                self.pageContainerView.isHidden = hide
            }
            if self.upgradeButton.isHidden != hide {
                self.upgradeButton.isHidden = hide
            }
            self.rightPanelStackView.arrangedSubviews.forEach {
                if $0 is UIButton && $0 != self.startButton {
                    if $0.isHidden != hide {
                        $0.isHidden = hide
                    }
                }
            }
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if navigationController == rightPanelNavigation {
            rightNavigationChanged(viewControllerCount: navigationController.viewControllers.count)

        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if navigationController == rightPanelNavigation {
            rightNavigationChanged(
                viewControllerCount: navigationController.viewControllers.count)
            
        } else if navigationController == bottomPanelNavigation {
            if navigationController.viewControllers.count == 1 {
                selectedLevel.duration = nil
            }
        }
    }
}

fileprivate
extension LevelListSuperViewController {
    func loadUI() {
        view.backgroundColor = .clear
        bottomPanelStackView.isHidden = true
        bottomPanelStackView.layer.zPosition = -1
        loadPageChild()
        loadBottomNavigationChild()
        loadRightNavigationChild()
    }
        
    func loadRightNavigationChild() {
        let nav = UINavigationController(
            rootViewController: LevelDescriptionViewController.initiate())
        nav.delegate = self
        nav.view.layer.name = Constants.Names.rightPanelNavigation.rawValue
        rightPanelStackView.insertArrangedSubview(nav.view, at: 1)
        addChild(nav)
        didMove(toParent: nav)
    }
    
    func updateBottomNavigationDifficulties(animated: Bool = false) {
        DispatchQueue.init(label: "db", qos: .userInitiated).async {
            let db = DataBaseService.db.completedLevels
            let completedKeys = db.keys.filter({
                ![
                    $0.levelPage == self.selectedLevel.levelPage,
                    $0.level == self.selectedLevel.level
                ].contains(false)
            })
            DispatchQueue.main.async {
                let vc = self.bottomPanelNavigation?.viewControllers.first as? DifficultyViewController
                vc?.updateData(Difficulty.allCases.compactMap({ difficulty in
                    let keys = completedKeys.filter({
                        $0.difficulty == difficulty
                    })
                    return .init(title: difficulty.rawValue, checkmarkCount: keys.count)
                }), animated: animated)
            }
        }
    }
    
    func loadBottomNavigationChild() {
        let rootVC = DifficultyViewController
            .initiate(
                data: Difficulty.allCases.compactMap({
                    .init(title: $0.rawValue, checkmarkCount: 0)
                }),
                didSelect: { value in
                    self.selectedLevel.difficulty = .init(rawValue: value)
                    self.toGameDurationPicker()

                })
        let nav = UINavigationController(
            rootViewController: rootVC)
        nav.delegate = self
        nav.view.backgroundColor = .red
        nav.view.layer.name = Constants.Names.bottomPanelNavigation.rawValue
        bottomPanelStackView.addArrangedSubview(nav.view)
        addChild(nav)
        didMove(toParent: nav)
        updateBottomNavigationDifficulties()
    }
    
    
    func loadPageChild() {
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

extension LevelListSuperViewController {
    struct Constants {
        enum Names: String {
            case rightPanelNavigation, bottomPanelNavigation
        }
    }
}
