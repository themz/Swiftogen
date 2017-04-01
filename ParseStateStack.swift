//
//  ParseStateStack.swift
//  swiftogen
//
//  Created by Mikhail Zinov on 29/03/2017.
//  Copyright © 2017 mz. All rights reserved.
//

import Foundation

enum ParseState {
    case _annotation
    case _class
    case _property
    case _start
}

class ParseStateStack {
    private var states: [ParseState] = []
    public var count: Int {
        return states.count
    }
    
    public func push(state: ParseState) {
        states.append(state)
    }
    
    public func top() -> ParseState {
        return states.last! //fastfail
    }
    
    @discardableResult
    public func pop() -> ParseState {
        return states.popLast()! //fastfail
    }
}
