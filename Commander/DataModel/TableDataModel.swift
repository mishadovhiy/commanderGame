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
    let higlighted: HiglightedType
    
    init(icon: String? = nil,
         title: String? = nil,
         text: String? = nil,
         higlighted: HiglightedType = .none
    ) {
        self.icon = icon
        self.title = title
        self.text = text
        self.higlighted = higlighted
    }
    
    enum HiglightedType: Codable {
        case none, distributed, accent
    }
}

struct SectionTableData {
    let section: String
    let tableData: [TableDataModel]
}
