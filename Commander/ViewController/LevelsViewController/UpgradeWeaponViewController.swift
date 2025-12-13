//
//  UpgradeWeaponViewController.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 13.12.2025.
//

import UIKit

class UpgradeWeaponViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension UpgradeWeaponViewController {
    static func initiate() -> Self {
        let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: .init(
                describing: Self.self)) as! Self
        return vc
    }
}
