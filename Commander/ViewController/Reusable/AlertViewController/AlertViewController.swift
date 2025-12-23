//
//  AlertViewController.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 23.12.2025.
//

import UIKit

class AlertViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var buttonsStackView: UIStackView!
    
    private var data: AlertModel!
    
    override func loadView() {
        
        super.loadView()
        loadChildVC()
        self.view.backgroundColor = .clear
    }
    
    func containerVC(_ data: AlertModel) -> AlertChildProtocol {
        switch data.type {
        case .tableView(_):
            AlertTableViewController.initiate(data)
        case .collectionView(_):
            AlertCollectionViewController.initiate(data)
        }
    }
    
    private func buttonDidPress(_ sender: UIButton) {
        buttonModelPressed(tag: sender.tag)
    }
    
    func buttonModelPressed(_ button: AlertModel.ButtonModel? = nil, tag: Int? = nil) {
        let childNav = children.first(where: {
            $0 is UINavigationController
        }) as? UINavigationController
        let vc = childNav?.viewControllers.last as? AlertChildProtocol
        let action = button ?? vc?.dataModel?.buttons[tag!]
        
        if let action = action?.didPress {
            action()
        } else if let dataModel = action?.toAlert {
            childNav?.pushViewController(containerVC(dataModel()), animated: true)
        }
    }
}


extension AlertViewController {
    func loadChildVC() {
        let nav = UINavigationController(rootViewController: containerVC(data))
        containerView.addSubview(nav.view)
        nav.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nav.view.leadingAnchor.constraint(equalTo: nav.view.superview!.leadingAnchor),
            nav.view.topAnchor.constraint(equalTo: nav.view.superview!.topAnchor),
            nav.view.bottomAnchor.constraint(equalTo: nav.view.superview!.bottomAnchor),
            nav.view.trailingAnchor.constraint(equalTo: nav.view.superview!.trailingAnchor)
        ])
        nav.didMove(toParent: self)
        addChild(nav)
    }

    func setupButtonsStack(for dataModel: AlertModel) {
        prepareSetupButtonsStack {
            dataModel.buttons.forEach { buttonData in
                let button = UIButton()
                button.tag = self.buttonsStackView.arrangedSubviews.count
                button.setTitle(buttonData.title, for: .init())
                self.buttonsStackView.addArrangedSubview(button)
            }
        }
    }
    
    func prepareSetupButtonsStack(completion: @escaping()->()) {
        if buttonsStackView.arrangedSubviews.isEmpty {
            completion()
        } else {
            let holder = buttonsStackView.arrangedSubviews
            buttonsStackView.arrangedSubviews.forEach { view in
                UIView.animate(withDuration: 0.3, animations: {
                    view.removeFromSuperview()
                }, completion: { _ in
                    if view == holder.last {
                        completion()
                    }
                })
            }
        }
    }
}

extension AlertViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let vc = viewController as? AlertChildProtocol else {
            fatalError()
        }
        self.setupButtonsStack(for: vc.dataModel!)
    }
}

extension AlertViewController {
    static func initiate(data: AlertModel) -> Self {
        let vc = Self.initiateDefault("Reusable")
        vc.data = data
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
}

protocol AlertChildProtocol: UIViewController {
    var dataModel: AlertModel? { get }
    static func initiate(_ dataModel: AlertModel) -> Self
}
