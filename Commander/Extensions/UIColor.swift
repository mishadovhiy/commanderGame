//
//  UIColor.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 07.01.2026.
//

import UIKit

extension UIColor {
    convenience init(hex: String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            self.init(red: 255, green: 0, blue: 0, alpha: 1)
            return
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    var isLight: Bool {
        let (r, g, b) = self.rgbInSRGB()
        let brightness = (r * 299 + g * 587 + b * 114) / 1000
        return brightness >= 0.5
    }

    private func rgbInSRGB() -> (CGFloat, CGFloat, CGFloat) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if getRed(&r, green: &g, blue: &b, alpha: &a) { return (r, g, b) }

        guard let srgb = cgColor.converted(
            to: CGColorSpace(name: CGColorSpace.sRGB)!,
            intent: .relativeColorimetric,
            options: nil),
              let comps = srgb.components
        else { return (0, 0, 0) }

        if comps.count == 2 {
            return (comps[0], comps[0], comps[0])
        } else {
            return (comps[0], comps[1], comps[2])
        }
    }
}
