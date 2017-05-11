//
//  Scanner.swift
//  swiftogen
//
//  Created by Mikhail Zinov on 25/03/2017.
//  Copyright © 2017 mz. All rights reserved.
//

import Foundation

struct PositionPointer {
    var line: Int
    var column: Int
    
    init(_ line: Int = 1, _ column: Int = 1) {
        self.line = line
        self.column = column
    }
    
    mutating func forward(_ count: Int = 1) {
        self.column += count
    }
    
    mutating func back(_ count: Int = 1) {
        self.column -= count
    }
    
    mutating func nextLine(_ count: Int = 1) {
        self.line += count
        self.column = 1
    }
    
    mutating func prevLine(_ count: Int = 1) {
        self.line -= count
        self.column = 1
    }
    
    func position() -> (line: Int, column: Int) {
        return (line, column)
    }
}

/* fileprivate enum SkipSymbols: Character {
    case whitespace = " "
    case tab = "\t"
    case newLine = "\n"
    case end = "eof"
}
 */

fileprivate enum ScannerState {
    case none
    case inWord         // 'var', 'class', etc
    case inSlash        // '/'
    case inComment      // /* */
    case inInlineComment// '//'
    case inAnnotation   // '/** */'
    case inAnnotationDeclaration
    case inAnnotationEnd // '*/'
    case inСolon        // ':'
    case inSeparator    // '}' '{'
    case inQuestion     // '?'
    case inBracketFront // '['
    case inBracketBack  // ']'
    case inStar         // '*'
    case inSign         // '@'
    case error
}

fileprivate let skipSymbols = " ;\n\t"
fileprivate let letterSymbols = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
fileprivate let separatorsSymbols = "{}"
fileprivate let bracketSymbols = "[]"
fileprivate let numberSymbols = "0123456789"

class Scanner {
    //char buffer
    private var container: CodeContainer
    private var pointer = PositionPointer()
    
    init(fileName: String) {
        do {
            let data = try String(contentsOf: URL(fileURLWithPath: fileName), encoding: String.Encoding.utf8)
            self.container = CodeContainer(data)
        }
        catch {
            print("Error file reading")
            exit(-1)
        }
    }
    
    func next() throws -> Lexeme {
        var buffer: String = ""
        var state: ScannerState = .none
        
        while let symbol = container.symbol() {
            updatePointer(symbol)
//            print(pointer.position(), symbol)
            switch state {
            case .none:
                if isSkip(symbol) { continue }
                else if isSlash(symbol) { state = .inSlash; continue }
                else if isLetter(symbol) { state = .inWord }
                else if isSeparator(symbol) { state  = .inSeparator }
                else if isSign(symbol) { state = .inAnnotationDeclaration }
                else if isStar(symbol) { state = .inAnnotationEnd; continue }
                else if isСolon(symbol) { return colonLexeme()}
                else if isQuestion(symbol) { return questionLexeme()}
                buffer += String(symbol)
            case .inAnnotation:
                if isSkip(symbol) { continue }
                else if isSign(symbol) {
                    buffer += String(symbol)
                    state = .inAnnotationDeclaration
                }
            case .inAnnotationDeclaration:
                if isLetter(symbol) {
                    buffer += String(symbol)
                } else if isSkip(symbol) {
                    return try! annotationLexeme(buffer)
                }
            case .inAnnotationEnd:
                if isSlash(symbol) {
                    state = .none
                    continue
                }
            case .inBracketBack:
                break
            case .inBracketFront:
                break
            case .inComment:
                if isStar(symbol) {
                    state = .inAnnotation
                }
            case .inSeparator:
                return separatorLexeme(buffer)
            case .inWord:
                if isLetter(symbol) || isNumber(symbol) {
                    buffer += String(symbol)
                } else {
                    state = identity(symbol: symbol)
                    if state == .inСolon || state == .inQuestion || state == .inSeparator {
                        container.back()
                    }
                    if state != .error {
                        return wordLexeme(buffer)
                    } else {
                        throw ScannerError(
                            line: pointer.line,
                            colomn: pointer.column,
                            message: "Unexpected symbol")
                    }
                }
            case .inInlineComment:
                if isNewLine(symbol) {
                    state = .none
                    buffer = ""
                }
            case .inSlash:
                if isSlash(symbol) {
                    state = .inInlineComment
                } else if isStar(symbol) {
                    state = .inComment
                }
            case .inQuestion:
                break
            case .inSign:
                break
            case .inStar:
                break
            case .inСolon:
                break
            case .error:
                break
            }
        }
        
        return EOFLexeme(position: LexemePosition(pointer: pointer))
    }
        
    private func isSkip(_ symbol: Character) -> Bool {
        return skipSymbols.contains(String(symbol))
    }
    
    private func isSlash(_ symbol: Character) -> Bool {
        return symbol == Character("/")
    }
    
    private func isLetter(_ symbol: Character) -> Bool {
        return letterSymbols.contains(String(symbol)) || symbol == "_"
    }
    
    private func isNumber(_ symbol: Character) -> Bool {
        return numberSymbols.contains(String(symbol))
    }
    
    private func isSeparator(_ symbol: Character) -> Bool {
        return separatorsSymbols.contains(String(symbol))
    }
    
    private func isStar(_ symbol: Character) -> Bool {
        return "*" == symbol
    }
    
    private func isNewLine(_ symbol: Character) -> Bool {
        return "\n" == symbol
    }
    
    private func isСolon(_ symbol: Character) -> Bool {
        return ":" == symbol
    }
    
    private func isSign(_ symbol: Character) -> Bool {
        return "@" == symbol
    }
    
    private func isQuestion(_ symbol: Character) -> Bool {
        return "?" == symbol
    }
    
    // MARK: -
    
    private func identity(symbol: Character) -> ScannerState {
        if isSeparator(symbol) {
            return .inSeparator
        } else if isSkip(symbol) {
            return .none
        } else if isСolon(symbol) {
            return .inСolon
        } else if isQuestion(symbol) {
            return .inQuestion
        }
        
        return .error
    }
    
    private func updatePointer(_ symbol: Character) {
        if isNewLine(symbol) {
            pointer.nextLine()
        } else {
            pointer.forward()
        }
    }
    
    // Mark - Lexeme
    
    private func wordLexeme(_ buffer: String) -> Lexeme {
        var type: ReserveredWord
        switch buffer {
        case ReserveredWord._class.rawValue:
            type = ._class
        case ReserveredWord._var.rawValue:
            type = ._var
        case ReserveredWord._let.rawValue:
            type = ._let
        case ReserveredWord._struct.rawValue:
            type = ._struct
        case ReserveredWord._import.rawValue:
            type = ._import
        default:
            return IdentificatorLexeme(buffer, position: LexemePosition(pointer: pointer))
        }
        
        return ReservedWordLexeme(type, position: LexemePosition(pointer: pointer))
    }
    
    private func annotationLexeme(_ buffer: String) throws -> Lexeme {
        let type: AnnotationType
        
        switch buffer {
        case AnnotationType.mapping.rawValue:
            type = .mapping
        default:
            throw ScannerError(
                line: pointer.line,
                colomn: pointer.column,
                message: "Unexpected annotation type")
        }
        
        return AnnotationLexeme(type, position: LexemePosition(pointer: pointer))
    }
    
    private func separatorLexeme(_ buffer: String) -> Lexeme {
        return SeparatorLexeme(buffer, position: LexemePosition(pointer: pointer))
    }
    
    private func colonLexeme() -> Lexeme {
        return Lexeme(type: .colon, position: LexemePosition(pointer: pointer), value: ":")
    }
    
    private func questionLexeme() -> Lexeme {
        return Lexeme(type: .question, position: LexemePosition(pointer: pointer), value: "?")
    }
}
