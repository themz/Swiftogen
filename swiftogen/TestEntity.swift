//
//  TestEntity.swift
//  swiftogen
//
//  Created by Mikhail Zinov on 25/03/2017.
//  Copyright © 2017 mz. All rights reserved.
//

import Foundation


class EntityWithId {
    
    
    /**
     @mapping id
     */
    let Id: Int = 0
    
    func a() -> Bool{
        return false
    }
    
}

class Post: EntityWithId {
    
}
