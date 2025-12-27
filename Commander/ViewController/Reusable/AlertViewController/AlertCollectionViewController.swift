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
        guard let array = dataModel?.type.data as? [AlertModel.TitleCellModel] else {
            fatalError()
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: .init(describing: AlertTitleCollectionCell.self), for: indexPath) as! AlertTitleCollectionCell
        cell.set(data: array[indexPath.row])

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let array = dataModel?.type.data as? [AlertModel.TitleCellModel] {
            parentVC?.buttonModelPressed(array[indexPath.row].button)

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
