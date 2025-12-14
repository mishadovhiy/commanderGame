//
//  UpgradeWeaponViewController.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 13.12.2025.
//

import UIKit

class UpgradeWeaponViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var collectionVIew: UICollectionView!
    private let collectionData: [WeaponType] = WeaponType.allCases
    private var tableData: [WeaponTableCellProtocol] = []
    private var selectedAt: Int? { didSet { updateTableData() }}
    
    override func loadView() {
        super.loadView()
        collectionVIew.delegate = self
        collectionVIew.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        self.view.backgroundColor = .black
        updateTableData()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func updateTableData() {
        let selectedWeaponType = collectionData[selectedAt ?? 0]
        tableData = [
            UserBalanceCellModel(balance: 200)
        ]
        if selectedAt != nil {
            tableData.append(WeaponTypeModel(
                title: selectedWeaponType.rawValue))
        }
        tableData.append(contentsOf: WeaponUpgradeType
            .allCases.compactMap({
            WeaponBuyModel(
                percent: 23,
                increesePercent: 15,
                level: 2,
                price: 200,
                type: $0)
        }))
        print(tableData.count, " tgerfwedaw ")
        tableView.reloadData()
    }
    
    func buyWeaponDidPress() {
        
    }
    
    @IBAction private func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension UpgradeWeaponViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier:
                    .init(describing: UpgradeWeaponCell.self),
            for: indexPath) as! UpgradeWeaponCell
        cell.set(collectionData[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedAt = indexPath.row
    }
}

extension UpgradeWeaponViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = tableData[indexPath.row]
        if let data = data as? UserBalanceCellModel {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: .init(describing: UserBalanceCell.self),
                for: indexPath) as! UserBalanceCell
            cell.set(data.balance, buyCoinsDidPress: { [weak self] in
                self?.navigationController?.pushViewController(
                    BuyCoinsViewController.initiate(), animated: true)
            })
            return cell
            
        } else if let data = data as? WeaponTypeModel {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: .init(describing: WeaponTypeCell.self),
                for: indexPath) as! WeaponTypeCell
            cell.set(data)
            return cell
            
        } else if let data = data as? WeaponBuyModel {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: .init(describing: WeaponBuyCell.self),
                for: indexPath) as! WeaponBuyCell
            cell.set(data, buyDidPress: self.buyWeaponDidPress)
            return cell
            
        } else {
            fatalError("\(data)")
        }
    }
    
    
}

extension UpgradeWeaponViewController {
    protocol WeaponTableCellProtocol { }
    
    struct UserBalanceCellModel: WeaponTableCellProtocol {
        let balance: Float
    }
    
    struct WeaponTypeModel: WeaponTableCellProtocol {
        let title: String
    }
    
    struct WeaponBuyModel: WeaponTableCellProtocol {
        let percent: Float
        let increesePercent: Int
        let level: Int
        let price: Int
        let type: WeaponUpgradeType
    }
    
    static func initiate() -> Self {
        let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: .init(
                describing: Self.self)) as! Self
        return vc
    }
}
