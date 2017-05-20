//
//  MappingGenerator.swift
//  swiftogen
//
//  Created by Mikhail Zinov on 02/04/2017.
//  Copyright © 2017 mz. All rights reserved.
//

import Foundation

/*
 Object mapper class generator
 */

class MappingGenerator: Generator {
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
        return "import Foundation\nimport ObjectMapper\n\n"
    }
    
    private func generateClass() -> String {
        let className = self.parser.symbolsTable.top()?.name
        let _classSymbol = self.parser.symbolsTable.top() as! ClassSymbol
        let superClassName = _classSymbol.superClassName
        
        var s = "class \(className! + mappingSuffix): "
        if superClassName != nil {
           s += superClassName! + mappingSuffix
        } else {
            s += "Mappable"
        }
        
        s += openBrace + newLine
        
        s += generateInit()
        var m = newLine + tab + "\(superClassName != nil ? "override " : "")func mapping(map: Map) {" + newLine
        
        if superClassName != nil {
            m += tab + tab + "super.mapping(map: map)" + newLine
        }
        
        let symbols = _classSymbol.symbolsTable.allSymbols()
        
        for symbol in symbols {
            if symbol.type == ._property {
                let propertySymbol = symbol as! PropertySymbol
                s += generate(property: propertySymbol)
                m += generateMappingAnnotation(property: propertySymbol)
            }
        }
        
        s += m + tab + closeBrace + newLine + closeBrace + newLine
        
        return s
    }
    
    private func generateInit() -> String {
        return newLine + tab + "required convenience init?(map: Map) { self.init() }" + newLine + newLine
    }
    
    private func generate(property: PropertySymbol) -> String {
        var s = tab + "var "
        
        if property.propertyType is ArrayTypeSymbol {
            let arrayType = (property.propertyType as! ArrayTypeSymbol).arrayType
            
            let typeName =  arrayType is BaseTypeSymbol ? arrayType.name : arrayType.name + mappingSuffix
            
            s += "\(property.propertyName): [\(typeName)]?" + newLine
        } else if  property.propertyType is BaseTypeSymbol {
            s += "\(property.propertyName): \(property.propertyType.name)?" + newLine
        } else if property.propertyType is CustomTypeSymbol {
            s += "\(property.propertyName): \(property.propertyType.name + mappingSuffix)?" + newLine
        }
        
        return s
    }
    
    private func generateMappingAnnotation(property: PropertySymbol) -> String {
        var s = ""
        for annotation in property.annotations {
            if annotation.annotationType == .mapping {
                s += tab
                    + tab
                    + "\(property.propertyName) <- map[\"\((annotation as! MappingAnnotationSymbol).mappingName)\"]"
                    + newLine
            }
        }
        
        return s
    }
}
