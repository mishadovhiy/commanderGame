//
//  AlertTableViewController.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 23.12.2025.
//

import UIKit

class AlertTableViewController: UIViewController, AlertChildProtocol {
    @IBOutlet private weak var tableView: UITableView!
    var dataModel: AlertModel?

    override func loadView() {
        super.loadView()
        view.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
    }

    var parentVC: AlertViewController? {
        (parent as? UINavigationController)?.parent as? AlertViewController
    }
    
    @objc func sliderDidChange(_ sender: UISlider) {
        var array = dataModel?.type.data as? [AlertModel.SegmentedCellModel]
        array?[sender.tag].segmentedChanged(CGFloat(sender.value))
        array?[sender.tag].segmentValue = CGFloat(sender.value)
        dataModel?.type = .tableView(array!)
    }
}

extension AlertTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataModel?.type.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let array = dataModel?.type.data as? [AlertModel.TitleCellModel] {
            let cell = tableView.dequeueReusableCell(withIdentifier: .init(describing: AlertTitleTableCell.self), for: indexPath) as! AlertTitleTableCell
            cell.set(data: array[indexPath.row])
            return cell
        } else if let array = dataModel?.type.data as? [AlertModel.SegmentedCellModel] {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: .init(describing: AlertSegmentedTableCell.self), for: indexPath) as! AlertSegmentedTableCell
            cell.set(data: array[indexPath.row])
            cell.segmentedView.tag = indexPath.row
            cell.segmentedView.addTarget(self, action: #selector(sliderDidChange(_:)), for: .valueChanged)
            return cell
        } else {
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let array = dataModel?.type.data as? [AlertModel.TitleCellModel] {
            parentVC?.buttonModelPressed(array[indexPath.row].button)
        }
    }
}

extension AlertTableViewController {
    static func initiate(_ dataModel: AlertModel) -> Self {
        let vc = Self.initiateDefault("Reusable")
        vc.dataModel = dataModel
        return vc
    }
}
