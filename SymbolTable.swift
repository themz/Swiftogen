//
//  SymbolTable.swift
//  swiftogen
//
//  Created by Mikhail Zinov on 29/03/2017.
//  Copyright © 2017 mz. All rights reserved.
//

import Foundation

class SymbolsTable {
    private var symbols: [Symbol] = []
    
    var size: Int {
        return self.symbols.count
    }
    
    open func add(symbol: Symbol) {
        symbols.append(symbol)
    }
    
    open func top() -> Symbol? {
        return symbols.first
    }
    
    open func allSymbols() ->  [Symbol] {
        return self.symbols
    }
    
}
