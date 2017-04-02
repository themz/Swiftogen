//
//  Generator.swift
//  swiftogen
//
//  Created by Mikhail Zinov on 02/04/2017.
//  Copyright © 2017 mz. All rights reserved.
//

import Foundation

protocol Generator {
    func generate() -> String
    func generateFileInfo() -> String
}
