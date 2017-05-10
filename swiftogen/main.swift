//
//  main.swift
//  swiftogen
//
//  Created by Mikhail Zinov on 25/03/2017.
//  Copyright © 2017 mz. All rights reserved.
//

import Foundation

let filename = CommandLine.arguments[2]
let filePath = CommandLine.arguments[3]
let name = ((filename.components(separatedBy: "/").last)?.components(separatedBy: ".").first)!

let parser = Parser(scanner: Scanner(fileName: filename))

do {
    try parser.parse()
    let mappingGenerator = MappingGenerator(parser: parser)
    var s = mappingGenerator.generate()
    mappingGenerator.touch(code: s, filePath: filePath, fileName: name)
    
} catch {
    print((error as! ParserError).localizedDescription)
}
