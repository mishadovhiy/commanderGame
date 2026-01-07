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
        if self.superview == s {
            return position
        } else {
            return self.superview?.positionInSuperview(position, s: s) ?? position
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            .init(cgColor: layer.borderColor ?? UIColor.clear.cgColor)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var hasDarkOverlay: Bool {
        get {
            layer.name?.contains("DarkOverlay") ?? false
        }
        set {
            if !newValue {
                return
            }
            if layer.name?.contains("DarkOverlay") ?? false {
                return
            }
            layer.name = "\(layer.name ?? "")DarkOverlay"
            addDarkOverlay()
        }
    }
    
    @IBInspectable var cornerRaious: CGFloat {
        get {
            layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var hasContainer: Bool {
        get {
            layer.name?.contains("hasContainer") ?? false
        }
        set {
            if !newValue {
                return
            }
            if layer.name?.contains("hasContainer") ?? false {
                return
            }
            layer.name = "\(layer.name ?? "")hasContainer"
            addSubview(ContainerMaskedView(isHorizontal: nil))
        }
    }
    
    func addDarkOverlay() {
        let view = DestinationOutMaskedView()
        view.layer.zPosition = 999
        view.isUserInteractionEnabled = false
        addSubview(view)
    }
    
    func addBlurView() {
        (0..<3).forEach { _ in
            addBlurItemView()
        }
    }
    
    private func addBlurItemView() {
        let style: UIBlurEffect.Style = .init(rawValue: -1000)!
        let effect = UIBlurEffect(style: style)
        let view = UIVisualEffectView(effect: effect)
        let vibracity = UIVisualEffectView(effect: effect)
        view.contentView.addSubview(vibracity)
        view.isUserInteractionEnabled = false
        insertSubview(view, at: 0)

        [view, vibracity].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: $0.superview!.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: $0.superview!.trailingAnchor),
                $0.topAnchor.constraint(equalTo: $0.superview!.topAnchor),
                $0.bottomAnchor.constraint(equalTo: $0.superview!.bottomAnchor)
            ])
        }
        
    }
}


