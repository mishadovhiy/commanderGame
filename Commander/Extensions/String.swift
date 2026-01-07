//
//  String.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 07.01.2026.
//

import Foundation

extension String {
    var addingSpacesBeforeLargeLetters: Self {
        self.replacingOccurrences(
                    of: "([a-z])([A-Z])",
                    with: "$1 $2",
                    options: .regularExpression
                )
    }
    
    var numbers: Int? {
        Int(self.filter({$0.isNumber}))
    }
}
