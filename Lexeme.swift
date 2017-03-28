//
//  Lexeme.swift
//  swiftogen
//
//  Created by Mikhail Zinov on 25/03/2017.
//  Copyright © 2017 mz. All rights reserved.
//

import Foundation


internal enum ReserverdWord: String {
    case _var = "var"
    case _let = "let"
    case _class = "class"
    case _struct = "struct"
    case _import = "import"
}

internal enum BaseTypes: String {
    case _int = "Int"
    case _float = "Float"
    case _bool = "Bool"
    case _double = "Double"
    case _string = "String"
}

internal enum AnnotationType: String {
    case mapping = "mapping"
}

internal enum AnnotationOptionsType: String {
    case optional = "optional"
}

internal enum AnnotationSymbols: String {
    case slash = "/"
    case backSlash = "\\"
    case dog = "@"
    case star = "*"
}

internal enum LexemeType {
    case reservedword
    case identificator
    case separator
    case annotation
    case type
    case endof
    case empty
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

class Lexeme {
    fileprivate let type: LexemeType?
    fileprivate var position: LexemePosition?
    fileprivate var value: String?
    
    init(type: LexemeType, position: LexemePosition, value: String) {
        self.type = type
        self.position = position
        self.value = value
    }
}

class ReservedWordLexeme: Lexeme {
    private let word: ReserverdWord
    
    init(_ word: ReserverdWord, position: LexemePosition) {
        self.word = word
        super.init(type: .reservedword, position: position, value: word.rawValue)
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

class AnnotationLexeme: Lexeme {
    private let annotationType: AnnotationType
    
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
