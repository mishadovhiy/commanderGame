//
//  UIApplication.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 07.01.2026.
//

import UIKit

extension UIApplication {
    var activeWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            if let windowScene = self.connectedScenes
                .first(where: {
                    $0.activationState == .foregroundActive
                }) as? UIWindowScene {
                
                if let keyWindow = windowScene.windows.first(where: {
                    $0.isKeyWindow
                }) {
                    return keyWindow
                }
            }
        }
        return UIApplication.shared.keyWindow
    }
}
