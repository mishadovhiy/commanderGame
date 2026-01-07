//
//  UILabel.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 07.01.2026.
//

import UIKit

extension UILabel {
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let _ = superview else {
            return
        }
        
        self.font = font.customFont()
    }
}
