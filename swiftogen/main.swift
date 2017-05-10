//
//  main.swift
//  swiftogen
//
//  Created by Mikhail Zinov on 25/03/2017.
//  Copyright © 2017 mz. All rights reserved.
//

import Foundation

let filename = CommandLine.arguments[2]

let parser = Parser(scanner: Scanner(fileName: filename))

do {
    try parser.parse()
    let mappingGenerator = MappingGenerator(parser: parser)
    print(mappingGenerator.generate())    
} catch {
    print((error as! ParserError).localizedDescription)
}
