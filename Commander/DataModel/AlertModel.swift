//
//  AlertModel.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 23.12.2025.
//

import Foundation
import UIKit

struct AlertModel {
    let title: String
    
    var type: ViewControllerType
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
        var segmentValue: CGFloat
        let segmentedChanged: (_ newValue: CGFloat)->()
    }
    
    struct TitleCellModel: AlertCellModel {
        let isSmallText: Bool
        let attributedString: NSAttributedString?
        let button: ButtonModel?
        private let unselectableTitle: String?
        
        init(button: ButtonModel? = nil,
             title: String? = nil,
             isSmallText: Bool = false,
             attributedString: NSAttributedString? = nil
        ) {
            self.button = button
            self.unselectableTitle = title
            self.isSmallText = isSmallText
            self.attributedString = attributedString
        }
        
        var title: String {
            button?.title ?? (unselectableTitle ?? "-")
        }
    }
    
    struct ButtonModel {
        let title: String
        let didPress: (()->())?
        let toAlert: (()->(AlertModel))?
        
        init(title: String,
             didPress: (() -> Void)? = nil,
             toAlert: (()->(AlertModel))? = nil) {
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
    static var settings: Self {
        return .init(title: "Settings", type: .collectionView([
            AlertModel.TitleCellModel(button: .init(title: "Sound", toAlert: {
                .init(title: "Sound", type: .soundSettingsData, buttons: [])
            }))
        ]), buttons: [])
    }
}

extension AlertModel.ViewControllerType {
    static var soundSettingsData: Self {
        var dict = try! DataBaseService.db.settings.sound.voluem.dictionary()
        return .dict(dict: dict, didUpdate: { newValue in
            DispatchQueue(label: "db", qos: .userInitiated).async {
                DataBaseService.db.settings.sound.voluem = try! .init(JSONSerialization.data(withJSONObject: newValue ?? [:], options: []))
                DispatchQueue.main.async {
                    (UIApplication.shared.activeWindow?.rootViewController as? BaseViewController)?.soundDidChange()
                }
            }
        })
    }
    
    static func dict(dict: [String:Any?]?, didUpdate:@escaping([String:Any?]?)->()) -> Self {
        var dict = dict
        return .tableView(
            dict?.keys.compactMap({ key in
                AlertModel.SegmentedCellModel(title: key, segmentValue: dict?[key] as? CGFloat ?? 0) { newValue in
                    dict?.updateValue(newValue, forKey: key)
                    didUpdate(dict)
//                    DispatchQueue(label: "db", qos: .userInitiated).async {
//                        DataBaseService.db.settings.sound.voluem = try! .init(JSONSerialization.data(withJSONObject: dict ?? [:], options: []))
//                    }
                }
            }) ?? []
        )
    }
}
