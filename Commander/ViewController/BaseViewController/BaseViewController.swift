//
//  BaseViewController.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 28.12.2025.
//

import UIKit

class BaseViewController: UIViewController {
    var didDismiss:(()->())?
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: {
            self.didDismiss?()
            self.didDismiss = nil
            completion?()
        })
    }
    
    deinit {
        didDismiss = nil
    }
    
    func soundDidChange() {
        if let vc = presentedViewController as? BaseViewController {
            vc.soundDidChange()
        }
        children.forEach {
            if let vc = $0 as? BaseViewController {
                vc.soundDidChange()
            }
        }
    }
}
