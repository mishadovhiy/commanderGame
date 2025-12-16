//
//  LevelDescriptionViewController.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 13.12.2025.
//

import UIKit

class LevelDescriptionViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    private var tableData: [SectionTableData] = []

    override func loadView() {
        super.loadView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(.init(nibName: .init(describing: TableDataCell.self), bundle: nil), forCellReuseIdentifier: .init(describing: TableDataCell.self))
        selectedLevelUpdated()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private var parentLevelListVC: LevelListSuperViewController? {
        (parent as? UINavigationController)?.parent as? LevelListSuperViewController
    }
      
    public func selectedLevelUpdated() {
        if self.view == nil {
            return
        }
        DispatchQueue(label: "db", qos: .userInitiated).async {
            let selectedLevel = self.parentLevelListVC?.selectedLevel ?? .init()
            print(selectedLevel, " ytregrfsdx")
            let db = DataBaseService.db.completedLevels
            let allLevelsForPageKeys = Array(DataBaseService.db.completedLevels.keys.filter({
                ($0.levelPage ?? "0") == selectedLevel.levelPage
            }))
            let allKeys = Array(DataBaseService.db.completedLevels.keys.filter({
                ($0.levelPage ?? "0") == selectedLevel.levelPage && $0.level == selectedLevel.level
            }))
            self.tableData = [
                .init(section: "", tableData: [
                    .init(
                        title: "level",
                        text: "\(self.parentLevelListVC?.selectedLevel.level ?? "0")"
                    ),
                    .init(
                        title: "page",
                        text: "\(self.parentLevelListVC?.selectedLevel.levelPage ?? "0")"
                    ),
                    .init(
                        title: "page levels",
                        text: "\(allLevelsForPageKeys.count)"
                    ),
                    .init(
                        title: "completed",
                        text: "\(allKeys.count)"
                    )
                ]),
                .init(section: "completed level difficulties", tableData:
                        allKeys.compactMap({
                            let value = db[$0]
                            return .init(title: $0.level, text: """
                                duration: \($0.duration?.rawValue ?? ""),
                                difficulty: \($0.difficulty?.rawValue ?? ""),
                                score: \(value?.score ?? 0),
                                $: \(value?.earnedMoney ?? 0)
                                """)
                        })
                     ),
                .init(section: "completed levels for page", tableData:
                        allLevelsForPageKeys.compactMap({
                            let value = db[$0]
                            return .init(title: $0.level, text: """
                                duration: \($0.duration?.rawValue ?? ""),
                                difficulty: \($0.difficulty?.rawValue ?? ""),
                                score: \(value?.score ?? 0),
                                $: \(value?.earnedMoney ?? 0)
                                """)
                        }))
            ]
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
}

extension LevelDescriptionViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        tableData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableData[section].tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: .init(describing: TableDataCell.self), for: indexPath) as? TableDataCell
        cell?.set(tableData[indexPath.section].tableData[indexPath.row])
        return cell ?? .init()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        tableData[section].section
    }
}


extension LevelDescriptionViewController {
    static func initiate() -> Self {
        let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: .init(
                describing: Self.self)) as! Self
        return vc
    }
}
