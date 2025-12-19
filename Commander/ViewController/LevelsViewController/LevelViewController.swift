//
//  LevelViewController.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 13.12.2025.
//

import UIKit

class LevelViewController: UIViewController {

    var data: LevelPagesBuilder!
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .clear
        drawLevelGround()
        loadLevelButtons()
        updateButtonsConstraints()
    }
    
    func drawLevelGround() {
        guard let view else {
            return
        }
        let path = CGMutablePath()
        path.move(to: .zero)
        
        data.levels.forEach { model in
            path.addLine(to: .init(
                x: view.frame.width * model.position.x,
                y: view.frame.height * model.position.y))
        }

        if let first = view.layer.sublayers?.first(where: {
            $0.name == "CAShapeLayer"
        }) as? CAShapeLayer {
            first.path = path
            return
        }

        
        let shape = CAShapeLayer()
        shape.path = path
        shape.name = "CAShapeLayer"
        shape.strokeColor = UIColor.red.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.lineWidth = 2
        view.layer.addSublayer(shape)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("ferwdasx ", view.frame.size)
        updateButtonsConstraints()
        drawLevelGround()
    }
    #warning("refactor")
    func updateButtonsConstraints() {
        print(view.constraints.count, " ytrtgerf ")
        if !view.constraints.isEmpty {
            view.constraints.forEach {
                if let button = ($0.firstItem as? UIButton ?? $0.secondItem as? UIButton) {
                    let position = self.data.levels[button.tag].position
                    if $0.firstAttribute == .leading {
                        $0.constant = view.frame.width * position.x
                    }
                    if $0.firstAttribute == .top {
                        $0.constant = view.frame.height * position.y
                    }
                }
                
            }
            view.setNeedsLayout()
            view.layoutSubviews()
            self.updateViewConstraints()
            view.updateConstraints()
            return
        }
        view.subviews.forEach { view in
            
            let position = self.data.levels[view.tag].position
            view.leadingAnchor.constraint(equalTo: view.superview!.leadingAnchor, constant: view.frame.width * position.x).isActive = true
            view.topAnchor.constraint(equalTo: view.superview!.topAnchor, constant: view.frame.height * position.y).isActive = true

            
            view.widthAnchor.constraint(equalToConstant: 50).isActive = true
            view.heightAnchor.constraint(equalToConstant: 50).isActive = true
            view.setNeedsLayout()
            view.layoutSubviews()
            view.updateConstraints()
        }
        view.setNeedsLayout()
        view.layoutSubviews()
        self.updateViewConstraints()
        view.updateConstraints()
    }
    
    func loadLevelButtons() {
        guard let view else {
            return
        }
        data.levels.forEach {
            let button = UIButton(type: .system)
            button.tag = view.subviews.count
            button.setTitle($0.title, for: .init())
            button.backgroundColor = .red
            button.addTarget(self, action: #selector(didSelectLevel(_:)), for: .touchUpInside)
//            button.isEnabled = $0 == data.levels.first
            view.addSubview(button)

            button.translatesAutoresizingMaskIntoConstraints = false
//            button.widthAnchor.constraint(equalToConstant: 50).isActive = true
//            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
//            let position = $0.position
//            button.frame.origin = .init(
//                x: view.frame.width * position.x,
//                y: view.frame.height * position.y)
        }
    }
    
    @objc func didSelectLevel(_ sender: UIButton) {
        (parent?.parent as? LevelListSuperViewController)!.selectedLevel = .init(level: data.levels[sender.tag].title, levelPage: (parent?.parent as? LevelListSuperViewController)!.selectedLevel.levelPage)
    }
}

extension LevelViewController {
    static func initiate(data: LevelPagesBuilder) -> Self {
        let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: .init(
                describing: Self.self)) as! Self
        vc.data = data
        return vc
    }
}
