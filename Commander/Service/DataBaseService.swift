//
//  DataBaseService.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 14.12.2025.
//

import Foundation

struct DataBaseService {
    fileprivate static var _db: DataBaseModel?
    static var db: DataBaseModel {
        get {
            let data = UserDefaults.standard.data(forKey: "db2")
            if let data = try? DataBaseModel.init(data) {
                return data
            }
            return .init()
        }
        set {
            UserDefaults.standard.setValue(try? newValue.encode() ?? .init(), forKey: "db2")
        }
    }
}
