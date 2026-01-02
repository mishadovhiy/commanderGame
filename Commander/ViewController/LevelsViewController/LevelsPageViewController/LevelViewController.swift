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
        setCompletedLevels()
    }
    
    private var parentVC: LevelListSuperViewController? {
        parent?.parent as? LevelListSuperViewController
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateButtonsConstraints()
        drawLevelGround()

    }
    
    func setCompletedLevels() {
        DispatchQueue(label: "db", qos: .userInitiated).async {
            let db = DataBaseService.db.completedLevels
            let keys = Array(db.keys)
            let last = self.parentVC?.completedLevels.sorted(by: {$0 >= $1}).last ?? 0
            let current = Int(self.data.title) ?? 0
            let isUlocked = last + 1 >= current
            DispatchQueue.main.async {
//                self.view.isUserInteractionEnabled = isUlocked
                if self.parentVC?.lockedLevelsView?.isHidden != isUlocked {
                    UIView.animate(withDuration: 0.3) {
                        self.parentVC?.lockedLevelsView?.isHidden = isUlocked
                    }
                }
                UIView.animate(withDuration: 0.2) {
                    self.view.alpha = isUlocked ? 1 : 0.5
                }
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
    
    #warning("refactor")
    func updateButtonsConstraints() {
        print(view.constraints.count, " ytrtgerf ")
        if !view.constraints.isEmpty {
            view.constraints.forEach {
                if let button = ($0.firstItem as? UIButton ?? $0.secondItem as? UIButton) {
                    let position = self.data.levels[button.tag].position
                    if $0.firstAttribute == .leading {
                        $0.constant = (view.frame.width * position.x) - (50 / 2)
                    }
                    if $0.firstAttribute == .top {
                        $0.constant = (view.frame.height * position.y) - (50 / 2)
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
    
    @objc private func didSelectLevel(_ sender: UIButton) {
        parentVC?.homeParentVC?.play(.menu2)
        parentVC?.selectedLevel = .init(
            level: data.levels[sender.tag].title,
            levelPage: parentVC!.selectedLevel.levelPage)
        parentVC?.homeParentVC?.setMap(for: parentVC?.homeParentVC?.currentPage, animated: false)
        let builder = GameBuilderModel(lvlModel: parentVC!.selectedLevel)
        var i = 0
        builder.enemyPerRound.forEach { round in
            print(i, " ", round, " rteds ", round.count)
            i += 1
        }
        print(" hyrtegfesda ", builder.rounds)
        view.subviews.forEach({
            if $0.layer.name == "levelButton" {
                let background = $0.subviews.first(where: {
                    $0.layer.name == "backgroundView"
                })
                background?.backgroundColor = sender.tag == $0.tag ? UIColor.accent.withAlphaComponent(0.4) : .dark.withAlphaComponent(0.15)
            }
        })
    }
}

fileprivate
extension LevelViewController {
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
        shape.strokeColor = UIColor.container.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.lineWidth = 2
        view.layer.addSublayer(shape)
    }

    
    func loadLevelButtonBackground(_ button: UIView) {
        let view = UIView()
        view.layer.name = "backgroundView"
        view.backgroundColor = .dark.withAlphaComponent(0.15)
        button.insertSubview(view, at: 0)
        view.insertSubview(ContainerMaskedView(isHorizontal: nil), at: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: view.superview!.leadingAnchor, constant: 5),
            view.trailingAnchor.constraint(equalTo: view.superview!.trailingAnchor, constant: -5),
            view.bottomAnchor.constraint(equalTo: view.superview!.bottomAnchor, constant: -5),
            view.topAnchor.constraint(equalTo: view.superview!.topAnchor, constant: 5)
        ])
        view.isUserInteractionEnabled = false
    }
    
    func loadLevelProgress(_ button: UIView) {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        Array(0..<3).forEach { i in
            let label = UIImageView(image: .star)
            label.contentMode = .scaleAspectFit
            label.tag = stack.arrangedSubviews.count
            stack.addArrangedSubview(label)
            label.widthAnchor.constraint(equalToConstant: 10).isActive = true
        }
        stack.spacing = 3
        stack.isUserInteractionEnabled = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: stack.superview!.centerXAnchor),
            stack.bottomAnchor.constraint(equalTo: stack.superview!.bottomAnchor, constant: 0),
            stack.heightAnchor.constraint(equalToConstant: 20)
        ])
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
            button.tintColor = .extraDark
//            button.layer.shadowColor = UIColor.black.cgColor
//            button.layer.shadowOffset = .init(width: 2, height: 2)
//            button.layer.shadowRadius = 4
//            button.layer.shadowOpacity = 0.3
//            button.backgroundColor = .red.withAlphaComponent(0.4)
            button.addTarget(self, action: #selector(didSelectLevel(_:)), for: .touchUpInside)
            view.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            loadLevelButtonBackground(button)

            loadLevelProgress(button)
        }
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
