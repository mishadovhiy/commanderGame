//
//  AlertCollectionViewController.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 23.12.2025.
//

import UIKit

class AlertCollectionViewController: UIViewController, AlertChildProtocol {

    @IBOutlet private weak var collectionView: UICollectionView!
    var dataModel: AlertModel?
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    var parentVC: AlertViewController? {
        (parent as? UINavigationController)?.parent as? AlertViewController
    }
}

extension AlertCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataModel?.type.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let data = dataModel?.type.data[indexPath.row] as? AlertModel.TitleCellModel {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: .init(describing: AlertTitleCollectionCell.self), for: indexPath) as! AlertTitleCollectionCell
            cell.set(data: data)

            return cell
        } else if let data = dataModel?.type.data[indexPath.row] as? AlertModel.LevelProgressModel {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: .init(describing: AlertLevelProgressCell.self), for: indexPath) as! AlertLevelProgressCell
            cell.set(data)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let data = dataModel?.type.data[indexPath.row] as? AlertModel.TitleCellModel {
            parentVC?.buttonModelPressed(data.button)

        }
    }
}

extension AlertCollectionViewController {
    static func initiate(_ dataModel: AlertModel) -> Self {
        let vc = Self.initiateDefault("Reusable")
        vc.dataModel = dataModel
        return vc
    }
}
