//
//  ArgumentError.swift
//  swiftogen
//
//  Created by Mikhail Zinov on 19/05/2017.
//  Copyright © 2017 mz. All rights reserved.
//

import Foundation

class ArgumentError: Error {
    private let message: String
    private let index: Int
    
    init(message: String = "", index: Int = 0) {
        self.index = index
        self.message = message
    }
    
    var localizedDescription: String {
        return "Unexpected argument at position \(index) with message \(message)"
    }
}
