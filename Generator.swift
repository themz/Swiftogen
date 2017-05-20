//
//  Generator.swift
//  swiftogen
//
//  Created by Mikhail Zinov on 02/04/2017.
//  Copyright © 2017 mz. All rights reserved.
//

import Foundation

let tab = "\t"
let newLine = "\n"
let openBrace = "{"
let closeBrace = "}"

let transformerSuffix = "MappingObjectTransformer"
let mappingSuffix = "MappingObject"

protocol Generator {
    func generate() -> String
    func touch(code: String, filePath: String, fileName: String, suffix: String)
}

extension Generator {
    func touch(code: String, filePath: String, fileName: String, suffix: String){
        let path =  URL(fileURLWithPath: filePath).appendingPathComponent("\(fileName)\(suffix).swift")
        do {
            try code.write(to: path, atomically: false, encoding: .utf8)
        }
        catch {
            print(error)
        }
    }
}


