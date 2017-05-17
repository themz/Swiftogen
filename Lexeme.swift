//
//  Lexeme.swift
//  swiftogen
//
//  Created by Mikhail Zinov on 25/03/2017.
//  Copyright © 2017 mz. All rights reserved.
//

import Foundation


internal enum ReserveredWord: String {
    case _var = "var"
    case _let = "let"
    case _class = "class"
    case _struct = "struct"
    case _import = "import"
}

internal enum AnnotationType: String {
    case mapping = "@mapping"
    case primary = "@primary"
    case none = ""
}

internal enum AnnotationOptionsType: String {
    case optional = "optional"
}

internal enum LexemeType {
    case reservedword
    case identificator
    case separator
    case annotation
    case colon
    case question
    case type
    case eof
    case empty
    case openBracket
    case closeBracket
}

struct LexemePosition{
    let line: Int
    let column: Int
    
    init(_ line: Int, _ column: Int)  {
        self.line = line
        self.column = column
    }
    
    init(line: Int, column: Int)  {
        self.line = line
        self.column = column
    }
    
    init(pointer: PositionPointer) {
        self.line = pointer.line
        self.column = pointer.column
    }
}

class Lexeme: Equatable {
    fileprivate let type: LexemeType?
    fileprivate var position: LexemePosition?
    internal var value: String!
    public var coordinate: (line: Int, colomn: Int) {
        return (line: position?.line ?? 0, colomn: position?.column ?? 0)
    }
    
    init(type: LexemeType, position: LexemePosition, value: String) {
        self.type = type
        self.position = position
        self.value = value
    }
    
    var description: String {
        return "\(value)"
    }
    
}

class ReservedWordLexeme: Lexeme {
    private let word: ReserveredWord
    public var rType: ReserveredWord {
        return word
    }
    
    init(_ word: ReserveredWord, position: LexemePosition) {
        self.word = word
        super.init(type: .reservedword, position: position, value: word.rawValue)
    }
    
    override var description: String {
        return "\(word.rawValue) " + super.description
    }
}

class IdentificatorLexeme: Lexeme {
    init(_ value: String, position: LexemePosition) {
        super.init(type: .identificator, position: position, value: value)
    }
}

class SeparatorLexeme: Lexeme {
    init(_ value: String, position: LexemePosition) {
        super.init(type: .separator, position: position, value: value)
    }
}

class EOFLexeme: Lexeme {
    init(position: LexemePosition) {
        super.init(type: .eof, position: position, value: "EOF")
    }
}

class AnnotationLexeme: Lexeme {
    let annotationType: AnnotationType
    
    init(_ type: AnnotationType, position: LexemePosition) {
        self.annotationType = type
        super.init(type: .annotation, position: position, value: annotationType.rawValue)
    }
}

class AnnotationOptionsLexeme: Lexeme {
    private let optionsType: AnnotationOptionsType
    
    init(_ type: AnnotationOptionsType, position: LexemePosition) {
        self.optionsType = type
        super.init(type: .annotation, position: position, value: optionsType.rawValue)
    }
}

//MARK: - Helpers

func ==(lhs: Lexeme, rhs: Lexeme) -> Bool {
    return lhs.type == rhs.type
}

func ==(lhs: Lexeme, rhs: LexemeType) -> Bool {
    return lhs.type == rhs
}


func !=(lhs: Lexeme, rhs: Lexeme) -> Bool {
    return !(lhs.type == rhs.type)
}

func !=(lhs: Lexeme, rhs: LexemeType) -> Bool {
    return !(lhs.type == rhs)
}

