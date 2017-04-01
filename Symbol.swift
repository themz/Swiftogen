//
//  Symbol.swift
//  swiftogen
//
//  Created by Mikhail Zinov on 28/03/2017.
//  Copyright © 2017 mz. All rights reserved.
//

import Foundation

enum SymbolType {
    case _property
    case _struct
    case _class
    case _type
    case _array
    case _dictionary
    case _empty
    case _annotation
}

class Symbol {
    open let name: String
    open let type: SymbolType
    
    init(_ name: String, type: SymbolType) {
        self.name = name
        self.type = type
    }
}

class EmptySymbol: Symbol {}

class ClassSymbol: Symbol {
    var symbolsTable = SymbolsTable()
    
    init(_ name: String) {
        super.init(name, type: ._class)
    }
    
}

class TypeSymbol: Symbol {
    init(name: String) {
        super.init(name, type: ._type)
    }
}

class PropertySymbol: Symbol {
    private var propertyName: String
    private var isConst: Bool
    private var propertyType: TypeSymbol
    
    init(
        name: String,
        isConst: Bool = false,
        type: TypeSymbol)
    {
        self.propertyName = name
        self.isConst = isConst
        self.propertyType = type
        super.init(name, type: ._property)
    }
}

// MARK: - Annotation

class AnnotationSymbol: Symbol {
    var annotationType: AnnotationType
    var correctOptions: [AnnotationOptionsType] = []
    
    init(name: String, annotationType: AnnotationType) {
        self.annotationType = annotationType
        super.init(name, type: ._annotation)
    }
}

class MappingAnnotationSymbol: AnnotationSymbol {
    private var options: [AnnotationOptionsType] = []
    private var mappingName: String
    
    init(mappingName: String) {
        self.mappingName = mappingName
        super.init(name: AnnotationType.mapping.rawValue, annotationType: .mapping)
        self.correctOptions = [.optional]
    }
}
