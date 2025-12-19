//
//  LevelListSuperView.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 13.12.2025.
//

import UIKit

class LevelListSuperViewController: UIViewController {
    
    @IBOutlet weak var bottomBarConstraint: NSLayoutConstraint!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var rightPanelStackView: UIStackView!
    @IBOutlet weak var upgradeButton: UIButton!
    @IBOutlet weak var bottomPanelStackView: UIStackView!
    @IBOutlet weak private var pageContainerView: UIView!
    
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
    
    var selectedLevel: LevelModel = .init(level: "", levelPage: "1") {
        didSet {
            let hide = self.selectedLevel.level.isEmpty
            let hideStart = selectedLevel.hasEmptyValue
            levelDescriptionVC?.selectedLevelUpdated()
            print(selectedLevel, " hyrgtfrdsd")
            if selectedLevel.duration == nil && self.bottomPanelNavigation?.viewControllers.count != 1 {
                bottomPanelNavigation?.popToRootViewController(animated: true)
            }
            if selectedLevel.difficulty == nil {
                (bottomPanelNavigation?.viewControllers.first as? DifficultyViewController)?.selectedAt = nil
            }
            UIView.animate(withDuration: 0.3, animations: {
                if hide != self.bottomPanelStackView?.isHidden {
                    self.bottomPanelStackView?.isHidden = hide
                }
                if self.startButton.isHidden != hideStart {
                    self.startButton.isHidden = hideStart
                }
            }, completion: { _ in
            })
        }
    }
    
    @IBAction func startGameDidPress(_ sender: Any) {
        self.present(GameViewController.initiate(self.selectedLevel), animated: true)
    }
    
    @IBAction func upgradeDidPress(_ sender: UIButton) {
        rightPanelNavigation?.pushViewController(UpgradeWeaponViewController.initiate(), animated: true)
    }
    
    func toGameDurationPicker() {
        self.bottomPanelNavigation?.pushViewController(
            DifficultyViewController.initiate(data: GameDurationType.allCases, didSelect: { value in
                self.selectedLevel.duration = .init(rawValue: value)
            }), animated: true)
    }
}

extension LevelListSuperViewController: UINavigationControllerDelegate {
    
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
    
    func loadBottomNavigationChild() {
        let rootVC = DifficultyViewController
            .initiate(
                data: Difficulty.allCases,
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
