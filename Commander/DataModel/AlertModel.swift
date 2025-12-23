//
//  AlertModel.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 23.12.2025.
//

import Foundation

struct AlertModel {
    let title: String
    
    let type: ViewControllerType
    let buttons: [ButtonModel]
    
    enum ViewControllerType {
        case tableView([AlertCellModel])
        case collectionView([AlertCellModel])
        
        var data: [AlertCellModel] {
            switch self {
            case .tableView(let array):
                array
            case .collectionView(let array):
                array
            }
        }
    }
    
    struct SegmentedCellModel: AlertCellModel {
        let title: String
        let segmentValue: CGFloat
        let segmentedChanged: (_ newValue: CGFloat)->()
    }
    
    struct TitleCellModel: AlertCellModel {
        let button: ButtonModel?
        private let unselectableTitle: String?
        
        init(button: ButtonModel? = nil, title: String? = nil) {
            self.button = button
            self.unselectableTitle = title
        }
        
        var title: String {
            button?.title ?? (unselectableTitle ?? "-")
        }
    }
    
    struct ButtonModel {
        let title: String
        let didPress: (()->())?
        let toAlert: AlertModel?
        
        init(title: String,
             didPress: (() -> Void)? = nil,
             toAlert: AlertModel? = nil) {
            self.title = title
            self.didPress = didPress
            self.toAlert = toAlert
        }
        
        enum `Type` {
            case disctructive, container, primary
        }
    }
}

protocol AlertCellModel {
    var title: String { get }
}

extension AlertModel {
    
    #warning("refactor: ini [SegmentedCellModel] from dictionary")
    static var soundSettings: Self {
        var dict = try? DataBaseService.db.settings.sound.voluem.dictionary() ?? [:]
        
        return .init(title: "Sound", type: .tableView(
            dict?.keys.compactMap({ key in
                Self.SegmentedCellModel(
                    title: key,
                    segmentValue: dict?[key] as? CGFloat ?? 0) { newValue in
                        dict?.updateValue(newValue, forKey: key)
                        DispatchQueue(label: "db", qos: .userInitiated).async {
                            DataBaseService.db.settings.sound.voluem = try! .init(JSONSerialization.data(withJSONObject: dict ?? [:], options: []))
                        }
                    }
            }) ?? []
        ), buttons: [])
    }
    
    static var settings: Self {
        return .init(title: "Settings", type: .collectionView([
            Self.TitleCellModel.init(button: .init(title: "Sound", toAlert: soundSettings))
        ]), buttons: [])
    }
}
