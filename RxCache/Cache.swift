//
//  Cache.swift
//  RxCache
//
//  Created by Jeremie Girault on 30/01/2017.
//  Copyright © 2017 Jeremie Girault. All rights reserved.
//

import RxSwift


/**
 * A Cache is a shared mutable state which contains Values indexed by Keys.
 * Cache should have reference semantics.
 * Cache operations may be asynchronous depending on the implementation. (e.g disk access may take some time)
 * However, even if asynchronous, all operations must garantee serial order.
 */
public protocol Cache {
    associatedtype Key
    associatedtype Value
    
    /**
     Queries the cache for a given key.
     Cold
     Next: The value associated to the provided key or nil if no value was present in the cache.
     Error: never.
     Completed: Queries the cache once and then completes.
     */
    func observable(for key: Key) -> Observable<Value?>
    
    /**
     Inserts or replaces a value in the cache for a given key.
     */
    mutating func set(_ value: Value?, for key: Key)
    
    /**
     Removes all values from the cache.
     */
    mutating func clear()
}
