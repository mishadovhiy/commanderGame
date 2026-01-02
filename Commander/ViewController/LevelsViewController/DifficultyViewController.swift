//
//  DifficultyViewController.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 13.12.2025.
//

import UIKit

class DifficultyViewController: AudioViewController {

    @IBOutlet weak var backNavigationButton: UIButton!
    @IBOutlet private weak var difficultyStackView: UIStackView!
    private var data: [DifficultyDataModel]!
    private var didSelect: ((_ value: String) -> ())!
    var selectedAt: Int? {
        didSet {
            difficultyStackView.arrangedSubviews.forEach { view in
                if view.tag >= 1 {
                    self.setButtonSelected(view: view, animated: true)
                }
            }
        }
    }
    
    override var audioFiles: [AudioFileNameType] {
        AudioFileNameType.allCases.filter({
            $0.type == .menu
        })
    }
    
    override func loadView() {
        super.loadView()
        backNavigationButton.isHidden = navigationController?.viewControllers.count == 1
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.view.backgroundColor = ContainerMaskedView.Constants.primaryBorderColor
        data.forEach { item in
            let button = UIButton(type: .system)
            button.tag = difficultyStackView.arrangedSubviews.count
            button.layer.name = item.title
            button.addTarget(self, action: #selector(difficultyPressed(_:)), for: .touchUpInside)
            difficultyStackView.addArrangedSubview(button)
            button.addSubview(ContainerMaskedView(isHorizontal: false))
        }
        print(difficultyStackView.arrangedSubviews.count, " egrfwdas")
        difficultyStackView.backgroundColor = ContainerMaskedView.Constants.primaryBorderColor
        self.updateData(data)
    }
    
    public func updateData(_ newData: [DifficultyDataModel], animated: Bool = false) {
        self.data = newData
        difficultyStackView.arrangedSubviews.forEach {
            let button = $0 as? UIButton
            let i = button?.tag ?? 0
            if i != 0 {
                print(i, " tefrwds ", newData.count, " trfedwsa")
                button?.setTitle(newData[i - 1].title + " (\(newData[i - 1].checkmarkCount))", for: .init())
                button?.isEnabled = !newData[i - 1].isLocked
                print(button?.title(for: .normal), " gtefrwdsa")
                setButtonSelected(view: button ?? $0, animated: animated)
            }
        }
    }
    
    private func setButtonSelected(view: UIView, animated: Bool = true) {
        UIView.animate(withDuration: 0.3) {
            view.backgroundColor = view.tag != self.selectedAt ? .dark : ContainerMaskedView.Constants.secondaryBorderColor
            view.tintColor = view.tag != self.selectedAt ? .init(hex: "E3E2DF") : .dark
        }
    }
    
    @objc private func difficultyPressed(_ sender: UIButton) {
        play(.menu2)
        didSelect(sender.layer.name ?? "")
        self.selectedAt = sender.tag
    }
    @IBAction private func backNavigationPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension DifficultyViewController {
    static func initiate(
        data: [DifficultyDataModel],
        didSelect: @escaping(_ value: String) -> ()
    ) -> Self {
        let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: .init(
                describing: Self.self)) as! Self
        vc.data = data
        vc.didSelect = didSelect
        return vc
    }
    
    struct DifficultyDataModel {
        let title: String
        let checkmarkCount: Int
        let isLocked: Bool
    }
}
