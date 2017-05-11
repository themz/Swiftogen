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
    
    func touch(code: String, filePath: String, fileName: String){
        let path =  URL(fileURLWithPath: filePath).appendingPathComponent("\(fileName)MappingObject.swift")
        do {
            try code.write(to: path, atomically: false, encoding: .utf8)
        }
        catch {
            print(error)
        }
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
        
        var s = "class \(className!)MappingObject: Mappable"
        if _classSymbol.superClassName != nil {
           s += ", \(_classSymbol.superClassName!)"
        }
        
        s += "{\n"
        
        s += generateInit()
        var m = "\n\tfunc mapping(map: Map) {\n"
        
        let symbols = _classSymbol.symbolsTable.allSymbols()
        
        for symbol in symbols {
            if symbol.type == ._property {
                let propertySymbol = symbol as! PropertySymbol
                s += generate(property: propertySymbol)
                m += generateMappingAnnotation(property: propertySymbol)
            }
        }
        
        m += "\t}\n"
        s += "\(m)}\n"
        
        return s
    }
    
    private func generateInit() -> String {
        return "\n\trequired convenience init?(map: Map) { self.init() }\n\n"
    }
    
    private func generate(property: PropertySymbol) -> String {
        return "\tvar \(property.propertyName): \(property.propertyType.name)?\n"
    }
    
    private func generateMappingAnnotation(property: PropertySymbol) -> String {
        var s = ""
        for annotation in property.annotations {
            if annotation.annotationType == .mapping {
                s += "\t\t\(property.propertyName) <- map[\"\((annotation as! MappingAnnotationSymbol).mappingName)\"]\n"
            }
        }
        
        return s
    }
}
