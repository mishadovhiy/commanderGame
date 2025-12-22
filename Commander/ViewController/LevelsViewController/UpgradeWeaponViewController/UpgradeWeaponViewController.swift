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
    var error: String? = nil
    
    override func loadView() {
        super.loadView()
        collectionVIew.delegate = self
        collectionVIew.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = ContainerMaskedView.Constants.primaryBorderColor
        self.view.backgroundColor = .black
        updateTableData()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        loadCellsSeparetor()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateTableData()
        self.navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
    private func updateTableData(completion: @escaping()->()={}) {
        DispatchQueue(label: "db", qos: .userInitiated).async {
            let selectedWeapon = self.collectionData[self.selectedAt ?? 0]
            let db = DataBaseService.db.upgradedWeapons
            self.tableData = [
                UserBalanceCellModel(balance: Float(KeychainService.getToken(forKey: .balance) ?? "") ?? 0)
            ]
            if self.selectedAt != nil {
                self.tableData.append(WeaponTypeModel(
                    title: selectedWeapon.rawValue))
            }
            
            self.tableData.append(contentsOf: WeaponUpgradeType
                .allCases.compactMap({
                    let lvl = db[selectedWeapon]?[$0] ?? 0
                    
                return WeaponBuyModel(
                    percent: Float(lvl) / (Float(selectedWeapon.maxUpgradeLevel) * Float($0.maxUpgradeDivider)),
                    increesePercent: 15,
                    level: lvl + 1,
                    price: selectedWeapon.upgradeStepPrice * (lvl + 1),
                    type: $0)
            }))
            print(self.tableData.count, " tgerfwedaw ")
            DispatchQueue.main.async {
                self.tableView.reloadData()
                completion()
            }
        }
    }
    
    @IBAction private func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func updateUserBalancePressed(_ sender: UIButton) {
        self.navigationController?.pushViewController(
            BuyCoinsViewController.initiate(), animated: true)
    }
    
    @objc func buyWeaponPressed(_ sender: UIButton) {
        error = nil
        tableView.reloadData()
        DispatchQueue(label: "db", qos: .userInitiated).async {
            let type: WeaponUpgradeType = .init(rawValue: sender.layer.name ?? "") ?? .attackPower
            let selectedWeapon = self.collectionData[self.selectedAt ?? 0]
            let balance = KeychainService.getToken(forKey: .balance) ?? ""
            let lvl = DataBaseService.db.upgradedWeapons[selectedWeapon]?[type] ?? 0
            let price = selectedWeapon.upgradeStepPrice * (lvl + 1)
            
            if Int(balance) ?? 0 >= price {
                let _ = KeychainService.saveToken("\((Int(balance) ?? 0) - price)", forKey: .balance)
                var updateDict = DataBaseService.db.upgradedWeapons[selectedWeapon] ?? [:]
                updateDict.updateValue(lvl + 1, forKey: type)
                DataBaseService.db.upgradedWeapons.updateValue(updateDict, forKey: selectedWeapon)
                DispatchQueue.main.async {
                    self.updateTableData()
                }
            } else {
                print("error not enought money")
            }
        }
        
    }
}

extension UpgradeWeaponViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: (collectionView.frame.width - 50) / 4,
              height: (collectionView.frame.width - 10) / 4)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
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
            cell.buyButton.addTarget(self, action: #selector(updateUserBalancePressed(_:)), for: .touchUpInside)
            cell.set(data.balance)
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
            cell.buyButton.addTarget(self, action: #selector(buyWeaponPressed(_:)), for: .touchUpInside)
            cell.set(data)
            return cell
            
        } else {
            fatalError("\(data)")
        }
    }
}

extension UpgradeWeaponViewController {
    func cellSeparetorCountH(_ size: CGFloat) -> Int {
        let countFloat = self.view.frame.height / size
        let countCalcH = CGFloat((collectionData.count / 4) + 1) * size
        let minCountH = Int(countFloat + 1)
        let count = Int(countCalcH) >= minCountH ? Int(countCalcH) : minCountH
        return count
    }
    
    func cellSeparetorHStack(_ size: CGFloat) -> UIStackView {
        let hstack = UIStackView()
        hstack.distribution = .fillEqually
        for _ in 0..<4 {
            let view = UIView()
            view.backgroundColor = .clear
            view.layer.borderColor = UIColor.red.cgColor
            view.layer.borderWidth = 1
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: size).isActive = true
            view.widthAnchor.constraint(equalToConstant: size).isActive = true

            hstack.addArrangedSubview(view)
        }
        return hstack
    }
    
    func loadCellsSeparetor() {
        let size = collectionVIew.frame.width / 4
        let count = cellSeparetorCountH(size)

        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.distribution = .fillEqually
        (0..<count).forEach { i in
            vStack.addArrangedSubview(
                cellSeparetorHStack(size)
            )
        }
        collectionVIew.addSubview(vStack)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.isUserInteractionEnabled = false
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: vStack.superview!.leadingAnchor),
            vStack.topAnchor.constraint(equalTo: vStack.superview!.topAnchor)
        ])
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
}
