//
//  ParserError.swift
//  swiftogen
//
//  Created by Mikhail Zinov on 28/03/2017.
//  Copyright © 2017 mz. All rights reserved.
//

import Foundation

class ParserError: Error {
    private let line: Int
    private let colomn: Int
    private let message: String
    
    init(line: Int = 0, colomn: Int = 0, message: String) {
        self.line = line
        self.colomn = colomn
        self.message = message
    }
    
    var localizedDescription: String {
        return message + " at line: \(self.line) colomn: \(self.colomn)"
    }
}
