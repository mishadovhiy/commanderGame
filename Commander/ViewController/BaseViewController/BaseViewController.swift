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
}
