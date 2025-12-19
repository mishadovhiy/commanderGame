//
//  DifficultyViewController.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 13.12.2025.
//

import UIKit

class DifficultyViewController: UIViewController {

    @IBOutlet weak var backNavigationButton: UIButton!
    @IBOutlet private weak var difficultyStackView: UIStackView!
    private var data: [any RawRepresentable]!
    private var didSelect: ((_ value: String) -> ())!
    var selectedAt: Int? {
        didSet {
            difficultyStackView.arrangedSubviews.forEach { view in
                UIView.animate(withDuration: 0.3) {
                    view.backgroundColor = view.tag != self.selectedAt ? .green : .red
                }
            }
        }
    }
    
    override func loadView() {
        super.loadView()
        backNavigationButton.isHidden = navigationController?.viewControllers.count == 1
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.view.backgroundColor = .red
        data.forEach { item in
            let button = UIButton(type: .system)
            button.tag = difficultyStackView.arrangedSubviews.count
            print(item.rawValue as? String, " gterfwdas")
            button.setTitle(item.rawValue as? String, for: .init())
            button.backgroundColor = .green
            button.layer.name = item.rawValue as? String
            button.addTarget(self, action: #selector(difficultyPressed(_:)), for: .touchUpInside)
            difficultyStackView.addArrangedSubview(button)
            button.addSubview(ContainerMaskedView(isHorizontal: false))
        }
        print(difficultyStackView.arrangedSubviews.count, " egrfwdas")
        difficultyStackView.backgroundColor = .orange
    }
    
    @objc private func difficultyPressed(_ sender: UIButton) {
        didSelect(sender.layer.name ?? "")
        self.selectedAt = sender.tag
    }
    @IBAction func backNavigationPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension DifficultyViewController {
    static func initiate(
        data: [any RawRepresentable],
        didSelect: @escaping(_ value: String) -> ()
    ) -> Self {
        let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: .init(
                describing: Self.self)) as! Self
        vc.data = data
        vc.didSelect = didSelect
        return vc
    }
}
