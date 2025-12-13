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

extension Encodable {
    func dictionary() throws -> [String:Any?]? {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any?]
            return json
        } catch {
            throw error
        }
    }
}
