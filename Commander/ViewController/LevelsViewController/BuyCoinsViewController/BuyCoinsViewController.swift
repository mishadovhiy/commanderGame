//
//  BuyCoinsViewController.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 14.12.2025.
//

import UIKit

class BuyCoinsViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    
    let options: [Int] = [40, 150, 300, 550, 800, 1200, 1500, 2000, -1]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    static func initiate() -> Self {
        let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: .init(
                describing: Self.self)) as! Self
        return vc
    }
}
extension BuyCoinsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: .init(describing: BuyCoinsCell.self), for: indexPath) as! BuyCoinsCell
        cell.set("\(options[indexPath.row])")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if options[indexPath.row] <= 0 {
            if options[indexPath.row] == -1 {
                DispatchQueue(label: "db", qos: .userInitiated).async {
                    DataBaseService.db.upgradedWeapons.removeAll()
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            return
        }
        let token = KeychainService.getToken(forKey: .balance) ?? ""
        let _ = KeychainService.saveToken("\((Int(token) ?? 0) + options[indexPath.row])", forKey: .balance)
        self.navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = collectionView.frame.width / 6
        if size <= 40 {
            size = 40
        }
        return .init(width: size, height: size)
    }
}
