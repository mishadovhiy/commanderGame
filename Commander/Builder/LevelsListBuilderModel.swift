//
//  LevelsListBuilderModel.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 13.12.2025.
//

import Foundation

struct LevelsListBuilderModel: Equatable {
    let title: String
    let levels: [LevelModel]
    
    struct LevelModel: Equatable {
        let position: CGPoint
        let title: String
    }
}

extension [LevelsListBuilderModel] {
    static var allData: Self {
        [
            .init(title: "1", levels: [
                .init(position:
                        .init(x: 0.1, y: 0.8),
                      title: "11"),
                .init(position:
                        .init(x: 0.1, y: 0.3),
                      title: "12"),
                .init(position:
                        .init(x: 0.14, y: 0.6),
                      title: "13"),
                .init(position:
                        .init(x: 0.25, y: 0.8),
                      title: "14"),
                .init(position:
                        .init(x: 0.28, y: 0.2),
                      title: "15"),
                .init(position:
                        .init(x: 0.08, y: 0.07),
                      title: "16"),
                .init(position:
                        .init(x: 0.38, y: 0.7),
                      title: "17")
            ]),
            .init(title: "2", levels: [
                .init(position:
                        .init(x: 0.1, y: 0.8),
                      title: "11"),
                .init(position:
                        .init(x: 0.11, y: 0.75),
                      title: "11"),
                .init(position:
                        .init(x: 0.08, y: 0.72),
                      title: "11"),
                .init(position:
                        .init(x: 0.086, y: 0.65),
                      title: "11"),
                .init(position:
                        .init(x: 0.1, y: 0.6),
                      title: "11"),
                .init(position:
                        .init(x: 0.1, y: 0.4),
                      title: "11"),
                .init(position:
                        .init(x: 0.1, y: 0.2),
                      title: "11"),
                .init(position:
                        .init(x: 0.07, y: 0.05),
                      title: "11"),
                .init(position:
                        .init(x: 0.21, y: 0.03),
                      title: "11"),
                .init(position:
                        .init(x: 0.23, y: 0.1),
                      title: "11")
            ]),
            .init(title: "3", levels: [
                .init(position:
                        .init(x: 0.1, y: 0.8),
                      title: "11"),
                .init(position:
                        .init(x: 0.11, y: 0.75),
                      title: "11"),
                .init(position:
                        .init(x: 0.08, y: 0.72),
                      title: "11"),
                .init(position:
                        .init(x: 0.086, y: 0.65),
                      title: "11"),
                .init(position:
                        .init(x: 0.1, y: 0.6),
                      title: "11"),
                .init(position:
                        .init(x: 0.1, y: 0.4),
                      title: "11"),
                .init(position:
                        .init(x: 0.1, y: 0.2),
                      title: "11"),
                .init(position:
                        .init(x: 0.07, y: 0.05),
                      title: "11"),
                .init(position:
                        .init(x: 0.21, y: 0.03),
                      title: "11"),
                .init(position:
                        .init(x: 0.23, y: 0.1),
                      title: "11")
            ])
        ]
    }
}
