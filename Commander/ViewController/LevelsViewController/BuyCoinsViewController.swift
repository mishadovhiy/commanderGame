//
//  BuyCoinsViewController.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 14.12.2025.
//

import UIKit

class BuyCoinsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    static func initiate() -> Self {
        let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: .init(
                describing: Self.self)) as! Self
        return vc
    }
}
