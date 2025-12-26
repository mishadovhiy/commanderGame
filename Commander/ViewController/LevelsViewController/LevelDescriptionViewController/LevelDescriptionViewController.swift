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
    private var levelsTableData: [CompletedLevelTableCell.ContentDataModel] = []
    private var pageOverviewTableData: PageLevelTableCell.ContentDataModel?
    
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
        allKeys: [LevelModel]
    ) -> [CompletedLevelTableCell.ContentDataModel] {
        guard let selectedLevel = parentLevelListVC?.selectedLevel else {
            return []
        }
        let completedLevels = Set(allKeys.compactMap({
            $0.level
        }))
        print(completedLevels.count, " gyrhtef")
        //todo: return list, for each level name
        var result: [CompletedLevelTableCell.ContentDataModel] = []
        completedLevels.forEach { levelName in
            result.append(
                .init(section: levelName,
                             data:
                        .init(topTitles: .init(
                            left: .init(GameDurationType.normal.rawValue),
                            middle: .init(GameDurationType.infinityHealth.rawValue),
                            right: .init(GameDurationType.singleLife.rawValue)),
                              tableData:
                                Difficulty.allCases
                            .compactMap({ difficulty in
                                    let keys = allKeys.filter({
                                        $0.difficulty == difficulty && $0.level == levelName
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
            )
        }
        return result
                        
    }
    
    private func multipleLevels(db: DataBaseModel, allKeys: [LevelModel]) -> [CompletedLevelTableCell.ContentDataModel] {
        var result: [CompletedLevelTableCell.ContentDataModel] = []
        GameDurationType.allCases.forEach { duration in
            let keys = allKeys.filter({
                $0.duration == duration
            })
            var progress: [Difficulty: GameProgress] = [:]
            Difficulty.allCases.forEach { difficulty in
                if let key = keys.first(where: {
                    $0.difficulty == difficulty
                }), let value = db.completedLevels[key] {
                    progress.updateValue(value, forKey: difficulty)
                }
            }
            if progress.isEmpty {
                return
            }
            result.append(.init(
                section: duration.rawValue,
                data: .init(
                    topTitles: .init(left: .init("earned"),
                                     middle: .init("enemy killed/passed"),
                                     right: .init("score")),
                    tableData: progress.compactMap({ (key: Difficulty,
                                                      value: GameProgress?) in
                            .init(section: .init(key.rawValue),
                                  content: .init(
                                    left: .init("\(value?.earnedMoney ?? 0)"),
                                    middle: .init("\(value?.killedEnemies ?? 0)/\(value?.passedEnemyCount ?? 0)"),
                                    right: .init("\(value?.score ?? 0)")))
                    }))))
        }
        return result
    }
    
    public func selectedLevelUpdated() {
        if self.view == nil {
            return
        }
        DispatchQueue(label: "db", qos: .userInitiated).async {
            let selectedLevel = self.parentLevelListVC?.selectedLevel ?? .init()
            let dataBase = DataBaseService.db
            let allLevelsForPageKeys = Array(dataBase.completedLevels.keys.filter({
                ($0.levelPage) == selectedLevel.levelPage
            }))
            let allKeys = Array(dataBase.completedLevels.keys.filter({
                ($0.levelPage) == selectedLevel.levelPage && $0.level == selectedLevel.level
            }))
            self.levelsTableData.removeAll()
            let builder = GameBuilderModel(lvlModel: selectedLevel)
            let levelBuilder = self.parentLevelListVC?.levelPageVC?.currentPageData
            let completedLevels = Set(allLevelsForPageKeys.compactMap({
                $0.level
            }))
            self.pageOverviewTableData = .init(pageModel: selectedLevel, builder: .init(data: builder), totalLevelCount: levelBuilder?.levels.count ?? 0, completedLevelCount: completedLevels.count)
            if !selectedLevel.level.isEmpty {
                self.levelsTableData = self.multipleLevels(db: dataBase, allKeys: allKeys)

            } else {
                self.levelsTableData = self.singleLevel(db: dataBase, allKeys: allLevelsForPageKeys)
            }
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
        case 0: 1
        case 1: self.levelsTableData.count
        default: 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let data = pageOverviewTableData else {
                return UITableViewCell()
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: .init(describing: PageLevelTableCell.self), for: indexPath) as! PageLevelTableCell
            cell.set(data: data)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: .init(describing: CompletedLevelTableCell.self), for: indexPath) as! CompletedLevelTableCell
            cell.set(data: levelsTableData[indexPath.row])
            return cell
        default:
            return UITableViewCell()
        }
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
