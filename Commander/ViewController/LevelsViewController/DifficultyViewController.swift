//
//  DifficultyViewController.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 13.12.2025.
//

import UIKit

class DifficultyViewController: UIViewController {

    @IBOutlet private weak var difficultyStackView: UIStackView!
    private var data: [any RawRepresentable]!
    private var didSelect: ((_ value: String) -> ())!
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .red
        data.forEach { item in
            let button = UIButton(type: .system)
            button.setTitle(item.rawValue as? String, for: .init())
            button.backgroundColor = .green
            button.layer.name = item.rawValue as? String
            button.addTarget(self, action: #selector(difficultyPressed(_:)), for: .touchUpInside)
            difficultyStackView.addArrangedSubview(button)
        }
        print(difficultyStackView.arrangedSubviews.count)
    }
    
    @objc private func difficultyPressed(_ sender: UIButton) {
        didSelect(sender.layer.name ?? "")
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
