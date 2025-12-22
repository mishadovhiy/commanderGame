//
//  DestinationOutMaskedView.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 18.12.2025.
//

import UIKit

class DestinationOutMaskedView: UIView {

    private var blackView: UIView? {
        subviews.first(where: {$0.layer.name == "blackView"})
    }
    
    init(type:Type = .button) {
        super.init(frame: .zero)
        self.layer.name = .init(describing: Self.self) + type.rawValue
    }
    
    private var type: Type? {
        Type.allCases.first(where: {
            self.layer.name?.contains($0.rawValue) ?? false
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        guard let _ = superview else {
            super.didMoveToSuperview()
            return
        }
        let type = self.type
        let blackView = UIView()
        blackView.backgroundColor = .dark
        blackView.layer.backgroundColor = UIColor.dark.withAlphaComponent(type != .borders ? 0.2 : 1).cgColor
        blackView.layer.name = "blackView"
        blackView.clipsToBounds = true
        addSubview(blackView)
        
        super.didMoveToSuperview()
        [self, blackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: $0.superview!.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: $0.superview!.trailingAnchor),
                $0.topAnchor.constraint(equalTo: $0.superview!.topAnchor),
                $0.bottomAnchor.constraint(equalTo: $0.superview!.bottomAnchor)
            ])
        }
        if type != .borders {
            blackView.addBlurView()
        }
        isUserInteractionEnabled = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        drawMask(frame)
    }
    
    private func drawMask(_ rect: CGRect) {
        let type = self.type
        let safeAreaInsets = type != .button ? safeAreaInsets : .init()
        let height = type == .button ? rect.height / 2 : rect.height - (4 + safeAreaInsets.top + safeAreaInsets.bottom)
        let pathRect = CGRect.init(origin: .init(x: 2 + safeAreaInsets.left, y: 2 + safeAreaInsets.top), size: .init(width: rect.width - (4 + (safeAreaInsets.left + safeAreaInsets.right)), height: height))
//        let pathRect = CGRect.init(origin: .init(x: 2, y: 2), size: .init(width: rect.width - 4, height: rect.height / 2))

        blackView?.layer.mask = MaskShape(frame: rect, pathRect)
    }
}

extension DestinationOutMaskedView {
    enum `Type`: String, CaseIterable {
        case button, borders
    }
}


class ContainerMaskedView: UIView {
    
    private let isHorizontal: Bool?
    let type: Type
    enum `Type` {
        case multiple
        case signle
    }
    
    struct Constants {
        static let largeBorderColor: UIColor = .init(hex: "39311D")
        static let borderColor: UIColor = .init(hex: "2B2515")
        static let secondaryBorderColor: UIColor = .container
        static let primaryBorderColor: UIColor = .init(hex: "594C29")
    }
    init(isHorizontal: Bool? = false, type: Type = .multiple) {
        self.isHorizontal = isHorizontal
        self.type = type
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let superview else {
            return
        }
        self.isUserInteractionEnabled = false
        superview.layer.masksToBounds = true
        let corners = UIView()
        corners.layer.name = "corners"
        addSubview(corners)
        
        let corner2 = UIView()
        if type != .signle {
            corners.addSubview(corner2)
        }

        [
            corners: (Constants.largeBorderColor, Constants.primaryBorderColor),
            corner2: (Constants.secondaryBorderColor, Constants.borderColor)
        ].forEach { (key: UIView, value: (UIColor, UIColor)) in
            key.backgroundColor = value.0
            key.layer.borderColor = value.1.cgColor
            key.layer.borderWidth = 2
        }
        
        
        let dict: [UIView: (CGFloat, CGFloat)]
        if type == .signle {
            dict = [
                corners: (0, 0),
                self: ((isHorizontal ?? false ? 0 : -1), (isHorizontal ?? false ? -2 : 0))
            ]
        } else {
            dict = [
                corners: (0, 0),
                corner2: (6, 6),
                self: ((isHorizontal ?? false ? 0 : -1), (isHorizontal ?? false ? -2 : 0))
            ]
        }
        dict.forEach { (key: UIView, value: (CGFloat, CGFloat)) in
            key.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                key.leadingAnchor.constraint(equalTo: key.superview!.leadingAnchor, constant: value.0),
                key.trailingAnchor.constraint(equalTo: key.superview!.trailingAnchor, constant: -value.0),
                key.topAnchor.constraint(equalTo: key.superview!.topAnchor, constant: value.1),
                key.bottomAnchor.constraint(equalTo: key.superview!.bottomAnchor, constant: -value.1)
            ])
        }
    }
    
    var corners: UIView? {
        subviews.first(where: {
            $0.layer.name == "corners"
        })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let corners else { return }
        let pathRect = CGRect.init(origin: .init(x: 10 + safeAreaInsets.left, y: 10 + safeAreaInsets.top), size: .init(width: corners.frame.width - (20 + (safeAreaInsets.left + safeAreaInsets.right)), height: corners.frame.height - (20 + (safeAreaInsets.top + safeAreaInsets.bottom))))
//        let pathRect = CGRect.init(origin: .init(x: 2, y: 2), size: .init(width: rect.width - 4, height: rect.height / 2))

        corners.layer.mask = MaskShape(frame: corners.frame, pathRect)
    }
}

class MaskShape: CAShapeLayer {
    init(frame: CGRect, _ pathRect: CGRect) {
        super.init()
        let path = CGMutablePath()
        path.addRoundedRect(in: pathRect, cornerWidth: 0, cornerHeight: 0)
        path.addRect(frame)
        
        self.backgroundColor = UIColor.red.cgColor
        self.path = path
        self.cornerRadius = 5
        self.fillRule = .evenOdd
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
