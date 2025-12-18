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

    
    override func didMoveToSuperview() {

        let blackView = UIView()
        blackView.backgroundColor = .black
        blackView.layer.backgroundColor = UIColor.black.withAlphaComponent(0.2).cgColor
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
        blackView.addBlurView()

    }

    override func draw(_ rect: CGRect) {
        drawMask(rect)
        super.draw(rect)
    }
    
    private func drawMask(_ rect: CGRect) {
        let pathRect = CGRect.init(origin: .init(x: 2, y: 2), size: .init(width: rect.width - 4, height: rect.height / 2))
        let path = CGMutablePath()
        path.addRoundedRect(in: pathRect, cornerWidth: 0, cornerHeight: 0)
        path.addRect(rect)
        
        let shape = CAShapeLayer()
        shape.backgroundColor = UIColor.red.cgColor
        shape.path = path
        shape.cornerRadius = 5
        shape.fillRule = .evenOdd
        blackView?.layer.mask = shape
    }
}
