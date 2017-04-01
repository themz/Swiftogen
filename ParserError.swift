//
//  ParseError.swift
//  swiftogen
//
//  Created by Mikhail Zinov on 31/03/2017.
//  Copyright © 2017 mz. All rights reserved.
//

import Foundation

class ParserError: Error {
    private let message: String
    private let lexeme: Lexeme
    
    init(lexeme: Lexeme, message: String = "") {
        self.lexeme = lexeme
        self.message = message
    }
    
    var localizedDescription: String {
        return message + "with lexeme \(lexeme) at line: \(lexeme.coordinate.line) colomn: \(lexeme.coordinate.colomn)"
    }
}
