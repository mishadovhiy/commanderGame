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
    private var levelsSectionData: [CompletedLevelTableCell.ContentDataModel] = []
    
    override func loadView() {
        super.loadView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(.init(nibName: .init(describing: TableDataCell.self), bundle: nil), forCellReuseIdentifier: .init(describing: TableDataCell.self))
        tableView.backgroundColor = ContainerMaskedView.Constants.primaryBorderColor
        selectedLevelUpdated()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private var parentLevelListVC: LevelListSuperViewController? {
        (parent as? UINavigationController)?.parent as? LevelListSuperViewController
    }
      
    
    private func singleLevel(
        db: DataBaseModel,
        allKeys: [LevelModel],
    ) -> CompletedLevelTableCell.ContentDataModel? {
        guard let selectedLevel = parentLevelListVC?.selectedLevel else {
            return nil
        }
        return .init(section: selectedLevel.level, data:
                .init(topTitles: .init(left: .init(GameDurationType.normal.rawValue), middle: .init(GameDurationType.infinityHealth.rawValue), right: .init(GameDurationType.singleLife.rawValue)), tableData:
                        Difficulty.allCases.compactMap({ difficulty in
                            let keys = allKeys.filter({
                                $0.difficulty == difficulty
                            })
                            if keys.isEmpty {
                                return .init(section: .init("-"), content: .init(left: .init("-"), middle: .init("-"), right: .init("-")))
                            }
                            var progress:[GameDurationType: GameProgress?] = [:]
                            GameDurationType.allCases.forEach({ duration in
                                if let key = keys.first(where: {
                                    $0.duration == duration
                                }) {
                                    progress.updateValue(db.completedLevels[key], forKey: duration)
                                }
                            })
                                                      
            return .init(section: .init(difficulty.rawValue),
                         content: .init(left: .init("\(progress[.normal]??.score ?? 0)"), middle: .init("\(progress[.infinityHealth]??.score ?? 0)"), right: .init("\(progress[.singleLife]??.score ?? 0)")))
                                                               
                                                              
                        })
                     ))
                        
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
            print(allKeys.count, " gfdvsdcxz ")
            self.levelsSectionData.removeAll()
            if !selectedLevel.level.isEmpty {
                let builder = GameBuilderModel(lvlModel: selectedLevel)
                if let table = self.singleLevel(db: DataBaseService.db, allKeys: allKeys) {
                    self.levelsSectionData = [table]

                }
                
            } else {
                //load from db durations
            }
//            self.tableData.removeAll()
//            self.tableData = [
//                .init(section: "", tableData: [
//                    .init(
//                        title: "page",
//                        text: "\(self.parentLevelListVC?.selectedLevel.levelPage ?? "0")"
//                    ),
//                    .init(
//                        title: "page completed",
//                        text: "\(allLevelsForPageKeys.count)"
//                    )
//                ])
//            ]
//            if !allKeys.isEmpty {
//                self.tableData[0].tableData.append(
//                    .init(
//                        title: "completed",
//                        text: "\(allKeys.count)"
//                    )
//                )
//            }
//            if self.parentLevelListVC?.selectedLevel.level.isEmpty == false {
//                let builder = GameBuilderModel(lvlModel: selectedLevel)
//                self.tableData[0].tableData.insert(.init(title: "Level \(self.parentLevelListVC?.selectedLevel.level ?? "")", text: """
//                        starting money: \(builder.startingMoney)
//                        rounds: \(builder.rounds)
//                        """), at: 0)
//            }
//            let progress: [String: [LevelModel]] = [
//                "completed level difficulties": allKeys,
//                "completed levels for page": (self.parentLevelListVC?.selectedLevel.level.isEmpty ?? true) ? allLevelsForPageKeys : []
//            ]
//            progress.forEach { (key: String, value: [LevelModel]) in
//                if !value.isEmpty {
//                    self.tableData.append(.init(section: key, tableData: value.compactMap({
//                        let value = db[$0]
//                        return [
//                            TableDataModel(title: "level: \($0.level)", text: """
//                                duration: \($0.duration?.rawValue ?? "")
//                                difficulty: \($0.difficulty?.rawValue ?? "")
//                                score: \(value?.score ?? 0)
//                                earned: $\(value?.earnedMoney ?? 0)
//                                """, higlighted: .accent)
//                        ]
//                    }).flatMap({$0})))
//                }
//                
//            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
}

extension LevelDescriptionViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
//        case 0: 0
        case 1: self.levelsSectionData.count
        default: 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return UITableViewCell()
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: .init(describing: CompletedLevelTableCell.self), for: indexPath) as! CompletedLevelTableCell
            cell.set(data: levelsSectionData[indexPath.row])
            return cell
        default:
            return UITableViewCell()
        }
//        let cell = tableView.dequeueReusableCell(withIdentifier: .init(describing: TableDataCell.self), for: indexPath) as? TableDataCell
//        cell?.set(tableData[indexPath.section].tableData[indexPath.row])
//        return cell ?? .init()
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
