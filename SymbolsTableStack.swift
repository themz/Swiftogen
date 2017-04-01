//
//  SymbolsTableStack.swift
//  swiftogen
//
//  Created by Mikhail Zinov on 31/03/2017.
//  Copyright © 2017 mz. All rights reserved.
//

import Foundation

class SymbolsTableStack {
    private var tables: [SymbolsTable] = []
    public var count: Int {
        return tables.count
    }
    
    public func push(state: SymbolsTable) {
        tables.append(state)
    }
    
    public func top() -> SymbolsTable {
        return tables.last! //fastfail
    }
    
    @discardableResult
    public func pop() -> SymbolsTable {
        return tables.popLast()! //fastfail
    }
}
