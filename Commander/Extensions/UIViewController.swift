//
//  UIViewController.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 07.01.2026.
//

import UIKit

extension UIViewController {
    static func initiateDefault(_ storyboardName: String = "Main") -> Self {
        let vc = UIStoryboard(name: storyboardName, bundle: nil)
            .instantiateViewController(
                withIdentifier: .init(
                    describing: Self.self
                )
            ) as! Self
        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
    
    func present(vc: UIViewController,
                 completion: @escaping()->() = {}) {
        if let presentedVC = self.presentedViewController {
            presentedVC.present(vc: vc, completion: completion)
        } else {
            self.present(vc, animated: true, completion: completion)
        }
    }
    
    func topPresentingViewController<T: UIViewController> (_ type: T.Type) -> T? {
        if let vc = self.presentedViewController {
            if let vc = vc as? T {
                return vc
            }
            return vc.topPresentingViewController(type)
        }
        return nil
    }
}
