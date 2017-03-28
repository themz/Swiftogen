//
//  Buffer.swift
//  swiftogen
//
//  Created by Mikhail Zinov on 27/03/2017.
//  Copyright © 2017 mz. All rights reserved.
//

import Foundation

class CodeContainer {
    private var data: String
    private var position: Int = 0
    
    init(_ data: String) {
        self.data = data
    }
    
    open func symbol() -> Character? {
        if !hasNext() {
            return nil
        }
        
        let index = data.index(data.startIndex, offsetBy: position)
        let symbol = data.characters[index]
        position += 1
        
        return symbol
    }
    
    open func prevSymbol() -> Character? {
        if position - 1 < 0 {
            return nil
        }
        
        let index = data.index(data.startIndex, offsetBy: position - 1)
        let symbol = data.characters[index]
        
        return symbol
    }
    
    open func back() {
        position -= 1
    }
    
    private func hasNext() -> Bool {
        return position < data.characters.count
    }
    
}

