//
//  MappingTransformer.swift
//  swiftogen
//
//  Created by Mikhail Zinov on 18/05/2017.
//  Copyright © 2017 mz. All rights reserved.
//

import Foundation

class MappingTransformerGenerator: Generator {
    private let parser: Parser
    
    init(parser: Parser) {
        self.parser = parser
    }
    
    func generate() -> String {
        return generateImports() + generateClass()
    }
    
    func generateFileInfo() -> String {
        return  ""
    }
    
    func generateImports() -> String {
        return "import Foundation" + newLine + newLine
    }
    
    private func generateClass() -> String {
        let className = (self.parser.symbolsTable.top()?.name)!
        let _classSymbol = self.parser.symbolsTable.top() as! ClassSymbol
        let superClassName = _classSymbol.superClassName
        
        var s = "class \(className)\(transformerSuffix) "
            + openBrace
            + newLine
        
        var m = newLine
            + tab
            + "@discardableResult"
            + newLine
            + tab
            + "func transform(from: \(className)MappingObject?, to: \(className)) -> \(className) "
            + openBrace
            + newLine
        
        if (superClassName != nil) {
            m += tab
            + tab
            + "\(_classSymbol.superClassName!)\(transformerSuffix)().transform(from: from, to: to)"
            + newLine
        }
        
        let symbols = _classSymbol.symbolsTable.allSymbols()
        
        for symbol in symbols {
            if symbol.type == ._property {
                let propertySymbol = symbol as! PropertySymbol
                m += generateTransform(property: propertySymbol, className: className)
            }
        }
        
        m += newLine
            + tab
            + tab
            + "return to"
            + newLine
            + tab
            + closeBrace
            + newLine
        
        s += m
            + closeBrace
            + newLine
        
        return s
    }
        
    private func generateTransform(property: PropertySymbol, className: String) -> String {
        var s = tab + tab

        if property.propertyType is ArrayTypeSymbol {
            let arrayType = (property.propertyType as! ArrayTypeSymbol).arrayType
            s += "to.\(property.name) = []" + newLine + tab + tab
            
            if arrayType is BaseTypeSymbol {
                s += "for x in from?.\(property.name) ?? [] "
                    + openBrace
                    + newLine
                    + tab
                    + tab
                    + tab
                    + "to.\(property.name)?.append(x)"
            } else {
                s += "for x in from?.\(property.name) ?? [] "
                    + openBrace
                    + newLine
                    + tab
                    + tab
                    + tab
                    + "to.\(property.name)?.append(\(arrayType.name)MappingObjectTransformer().transform(from:x, to: \(arrayType.name)()))"
            }
            s += newLine
                + tab
                + tab
                + closeBrace
                + newLine
        } else if  property.propertyType is BaseTypeSymbol {
            s += "to.\(property.name) = from?.\(property.name)" + newLine
        } else if property.propertyType is CustomTypeSymbol {
            s += "to.\(property.name) = \(property.propertyType.name)MappingObjectTransformer().transform(from: from?.\(property.name), to: \(property.propertyType.name)())" + newLine
        } else {
            
        }
        
        return s
    }
}
