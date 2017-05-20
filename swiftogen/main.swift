//
//  main.swift
//  swiftogen
//
//  Created by Mikhail Zinov on 25/03/2017.
//  Copyright © 2017 mz. All rights reserved.
//

import Foundation

let typeKey = CommandLine.arguments[1]
let filename = CommandLine.arguments[2]
let filePath = CommandLine.arguments[3]
let name = ((filename.components(separatedBy: "/").last)?.components(separatedBy: ".").first)!

let parser = Parser(scanner: Scanner(fileName: filename))

do {
    try parser.parse()
    let generator: Generator!
    if typeKey == "-m" {
        generator = MappingGenerator(parser: parser)
        generator.touch(code: generator.generate(),
                               filePath: filePath,
                               fileName: name,
                               suffix: mappingSuffix)
        print("Create file \(name + mappingSuffix).swift")
    } else if typeKey == "-t" {
        generator = MappingTransformerGenerator(parser: parser)
        generator.touch(code: generator.generate(),
                               filePath: filePath,
                               fileName: name,
                               suffix: transformerSuffix)
        print("Create file \(name + transformerSuffix).swift")
    } else {
        throw ArgumentError(message: "", index: 1)
    }
    
    
} catch {
    print((error as! ParserError).localizedDescription + " at file \(name)")
}
