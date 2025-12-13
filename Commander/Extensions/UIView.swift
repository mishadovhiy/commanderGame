//
//  UIView.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 13.12.2025.
//

import UIKit

extension UIView {
    func positionInSuperview(_ position: CGPoint = .zero, s: UIView) -> CGPoint {
        var position = position
        position.x += frame.minX
        position.y += frame.minY
        print(position, " positionpositionposition")
        if self.superview == s {
            return position
        } else {
            return self.superview?.positionInSuperview(position, s: s) ?? position
        }
    }
}
