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
            $0 is UINavigationController && $0.view?.layer.name == "rightPanelNavigation"
        }) as? UINavigationController
    }
    
    var bottomPanelNavigation: UINavigationController? {
        children.first(where: {
            $0 is UINavigationController && $0.view?.layer.name == "bottomPanelNavigation"
        }) as? UINavigationController
    }
    
    var levelDescriptionVC: LevelDescriptionViewController? {
        rightPanelNavigation?.viewControllers.first(where: {
            $0 is LevelDescriptionViewController
        }) as? LevelDescriptionViewController
    }
    
    var selectedLevel: LevelModel? {
        didSet {
            let newValueDict = try? selectedLevel?.dictionary()
            print(selectedLevel, " tgerfwd")
            UIView.animate(withDuration: 0.3, animations: {
                self.bottomPanelStackView?.isHidden = self.selectedLevel == nil
                self.startButton.isHidden = newValueDict?.values.contains(where: {$0 == nil}) ?? true
            }, completion: { _ in
            })
        }
    }
    
    @IBAction func startGameDidPress(_ sender: Any) {
        print(selectedLevel)
    }
    
    @IBAction func upgradeDidPress(_ sender: UIButton) {
        rightPanelNavigation?.pushViewController(UpgradeWeaponViewController.initiate(), animated: true)
    }
    
    func toGameDurationPicker() {
        self.bottomPanelNavigation?.pushViewController(
            DifficultyViewController.initiate(data: GameDurationType.allCases, didSelect: { value in
                self.selectedLevel?.duration = .init(rawValue: value)
            }), animated: true)
    }
}

extension LevelListSuperViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if navigationController == rightPanelNavigation {
            if navigationController.viewControllers.count == 1 {
                self.selectedLevel = self.selectedLevel ?? nil
            }
            UIView.animate(withDuration: 0.3) {
                self.bottomPanelStackView.isHidden = navigationController.viewControllers.count > 1
                self.pageContainerView.isHidden = navigationController.viewControllers.count > 1
                self.upgradeButton.isHidden = navigationController.viewControllers.count > 1
            }
        } else if navigationController == bottomPanelNavigation {
            if navigationController.viewControllers.count == 1 {
                selectedLevel?.duration = nil
            }
        }
    }
}

extension LevelListSuperViewController {
    func loadUI() {
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
        nav.view.layer.name = "rightPanelNavigation"
        rightPanelStackView.addArrangedSubview(nav.view)
        addChild(nav)
        didMove(toParent: nav)
    }
    
    func loadBottomNavigationChild() {
        let rootVC = DifficultyViewController
            .initiate(
                data: Difficulty.allCases,
                didSelect: { value in
                    self.selectedLevel?.difficulty = .init(rawValue: value)
                    self.toGameDurationPicker()
                })
        let nav = UINavigationController(
            rootViewController: rootVC)
        nav.delegate = self
        nav.view.backgroundColor = .red
        nav.view.layer.name = "bottomPanelNavigation"
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
