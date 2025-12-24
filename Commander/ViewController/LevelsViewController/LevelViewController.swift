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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue(label: "db", qos: .userInitiated).async {
            let db = DataBaseService.db.completedLevels
            let keys = Array(db.keys)
            DispatchQueue.main.async {
                self.view.subviews.forEach { button in
                    if button.layer.name == "levelButton",
                       let stack = button.subviews.first(where: {
                           $0 is UIStackView
                       }) as? UIStackView
                    {
                        
                        stack.arrangedSubviews.forEach { label in
                            let completed = keys.contains(where: {
                                ![
                                    $0.level == self.data.levels[button.tag].title,
                                    $0.levelPage == self.parentVC!.selectedLevel.levelPage,
                                    $0.difficulty == .allCases[label.tag]
                                ].contains(false)
                                
                            })
                            label.alpha = completed ? 1 : 0.2
                        }
                    }
                }
            }
        }
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
            UIView.animate(withDuration: 0.2, animations: {
                self.view.setNeedsLayout()
            }, completion: { _ in

            })
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
        UIView.animate(withDuration: 0.2, animations: {
            self.view.setNeedsLayout()
        }, completion: { _ in

        })
    }
    
    func loadLevelButtons() {
        guard let view else {
            return
        }
        data.levels.forEach {
            let button = UIButton(type: .system)
            button.tag = view.subviews.count
            button.layer.name = "levelButton"
            button.setTitle($0.title, for: .init())
            button.backgroundColor = .red.withAlphaComponent(0.4)
            button.addTarget(self, action: #selector(didSelectLevel(_:)), for: .touchUpInside)
            view.addSubview(button)
            button.layer.cornerRadius = 25
            button.layer.masksToBounds = true
            button.translatesAutoresizingMaskIntoConstraints = false
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .fillEqually
            Array(0..<3).forEach { i in
                let label = UILabel()
                label.text = "\(i)"
                label.font = .systemFont(ofSize: 9)
                label.textAlignment = .center
                label.tag = stack.arrangedSubviews.count
                label.textColor = .white
                stack.addArrangedSubview(label)
            }
            stack.translatesAutoresizingMaskIntoConstraints = false
            button.addSubview(stack)
            NSLayoutConstraint.activate([
                stack.leadingAnchor.constraint(equalTo: stack.superview!.leadingAnchor),
                stack.trailingAnchor.constraint(equalTo: stack.superview!.trailingAnchor),
                stack.bottomAnchor.constraint(equalTo: stack.superview!.bottomAnchor),
                stack.heightAnchor.constraint(equalToConstant: 20)
            ])
        }
    }
    
    private var parentVC: LevelListSuperViewController? {
        parent?.parent as? LevelListSuperViewController
    }
    
    @objc func didSelectLevel(_ sender: UIButton) {
        let selectedHolder = parentVC?.selectedLevel
        parentVC?.selectedLevel = .init(
            level: data.levels[sender.tag].title,
            levelPage: parentVC!.selectedLevel.levelPage)
        parentVC?.homeParentVC?.setMap(for: parentVC?.homeParentVC?.currentPage, animated: false)
        view.subviews.forEach({
            if $0.layer.name == "levelButton" {
                $0.backgroundColor = (sender.tag == $0.tag ? UIColor.green : .red).withAlphaComponent(0.4)
            }
        })
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
