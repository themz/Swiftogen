//
//  Parser.swift
//  swiftogen
//
//  Created by Mikhail Zinov on 25/03/2017.
//  Copyright © 2017 mz. All rights reserved.
//

import Foundation

enum ParserState {
    case start
    case comment
    case notation
    case defenition
    case end
}

class Parser {
    private let scanner: Scanner
    private var cl: Lexeme! // currentLexeme
    private let stateStack = ParseStateStack()
    private let symbolsTableStack = SymbolsTableStack()
    
    open var symbolsTable: SymbolsTable {
        return self.symbolsTableStack.top()
    }
    
    init(scanner: Scanner) {
        self.scanner = scanner
        stateStack.push(state: ._start)
        symbolsTableStack.push(state: SymbolsTable())
        
        next()
    }
    
    private func next() {
        do {
            cl = try scanner.next()
//            print(cl)
        } catch {
            print((error as! ScannerError).localizedDescription)
        }
    }
    
    private func hasNext() -> Bool {
        return cl != .eof
    }

    open func parse() throws {
        while(hasNext()) {
            try parseDeclaration()
        }
        
        if self.stateStack.top() == ._start {
            try self.rebuildAnnotationsAfter()
        }
    }
    
    private func parseDeclaration() throws {
        if cl == .annotation {
            try parseAnnotation()
        } else if cl == .reservedword {
            switch (cl as! ReservedWordLexeme).rType {
            case ._class:
                if stateStack.top() == ._class {
                    throw ParserError( lexeme: cl, message: "Can't add class in class")
                }
                try parseClass()
            case ._import:
                next()
                next()
            case ._let:
                throw ParserError(lexeme: cl, message: "Dos't support yet")
            case ._var:
                try parseProperty()
            case ._struct:
                throw ParserError(lexeme: cl, message: "Dos't support yet")
            }
        } else if (cl == .separator) {
            next()
        }
    }
    
    private func parseClass() throws {
        stateStack.push(state: ._class)
        next()
        if cl != .identificator {
            throw ParserError(lexeme: cl, message: "Class name expacted ")
        }
        let _classSymbol = ClassSymbol(cl.value)
        self.symbolsTableStack.top().add(symbol: _classSymbol)
        self.symbolsTableStack.push(state: _classSymbol.symbolsTable)
        next()
        if cl == .colon {
            next()
            if (cl != .identificator) {
                throw ParserError(lexeme: cl, message: "Expected super class ")
            }
            _classSymbol.superClassName = cl.value
            next()
        }
        
        if cl != .separator {
            throw ParserError(lexeme: cl, message: "Expected separator ")
        }
        next()
        try parse()
        stateStack.pop() //.class
        symbolsTableStack.pop()
    }
    
    private func parseAnnotation() throws {
        stateStack.push(state: ._annotation)
        switch (cl as! AnnotationLexeme).annotationType {
        case .mapping:
            try parseMappingAnnotation()
        case .none:
            throw ParserError(lexeme: cl, message: "Unexpacted annotation type")
        case .primary:
            throw ParserError(lexeme: cl, message: "Unexpacted annotation type")
        }
        stateStack.pop() //.annotation
    }
    
    private func parseProperty() throws {
        stateStack.push(state: ._property)
        next()
        if cl != .identificator {
            throw ParserError(lexeme: cl, message: "Expacted property name")
        }
        let name: String = cl.value
        next()
        if cl != .colon {
            throw ParserError(lexeme: cl, message: "Expacted colon")
        }
        next()
        if cl != .identificator {
            throw ParserError(lexeme: cl, message: "Expacted property type")
        }
        let type = TypeSymbol(name: cl.value)
        let property = PropertySymbol(name: name, type: type)
        symbolsTableStack.top().add(symbol: property)
        next()
        next() //  skip '?'
        stateStack.pop() //.property
    }
    
    // MARK: - Annotations
    
    private func parseMappingAnnotation() throws {
        next()
        if cl != .identificator {
            throw ParserError(lexeme: cl, message: "Expacted annotation value ")
        }
        let annotation = MappingAnnotationSymbol(mappingName: (cl as! IdentificatorLexeme).value)
        self.symbolsTableStack.top().add(symbol: annotation)
        next()
        try parse()
    }
    
    private func rebuildAnnotationsAfter() throws {
        let classSymbol = self.symbolsTable.top() as! ClassSymbol
        let symbols = classSymbol.symbolsTable.allSymbols()
        
        var propertyAnnotations = [AnnotationSymbol]()
        
        for s in symbols {
            if s.type == ._annotation {
                propertyAnnotations.append(s as! AnnotationSymbol)
            } else if s.type == ._property {
                (s as! PropertySymbol).annotations = propertyAnnotations
                propertyAnnotations = [AnnotationSymbol]()
            } else {
                throw ParserError(lexeme: cl, message: "Unexpected symbol ")
            }
        }
    }
}
