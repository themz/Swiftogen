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
    private let classSymbol: ClassSymbol
    
    init(classSymbol: ClassSymbol) {
        
    }
    
    func generate() -> String {
        let file =
        generateFileInfo() +
        generateInit() +
        generateMappings()
        
        print(file)
    }
    
    func generateFileInfo() -> String {
        return  "//" +
            "// Swiftogen" +
            "// Geneated mapping class for \(classSymbol.name)" +
            "// Generated at \(Date())" +
            "//"
            "// Copyright © 2017 mz. All rights reserved."
    }
    
    private func generateInit() -> String {
        return "required convenience init?(map: Map) { self.init() }"
    }
    
    private func generateMappings() {}
}
