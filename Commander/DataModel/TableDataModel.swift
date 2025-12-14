//
//  TableDataModel.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 14.12.2025.
//

import Foundation

struct TableDataModel {
    let icon: String?
    let title: String?
    let text: String?
    
    init(icon: String? = nil,
         title: String? = nil,
         text: String? = nil) {
        self.icon = icon
        self.title = title
        self.text = text
    }
}

struct SectionTableData {
    let section: String
    let tableData: [TableDataModel]
}
