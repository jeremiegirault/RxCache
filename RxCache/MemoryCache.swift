//
//  MemoryCache.swift
//  RxCache
//
//  Created by Jeremie Girault on 30/01/2017.
//  Copyright © 2017 Jeremie Girault. All rights reserved.
//

import Foundation

// todo: implement key/value holder for values implementing NSDiscardableContent to avoid direct eviction while going to background
// + ValueHolder will be an anyObject able to hold structs

fileprivate class ValueHolder<T> {
    let value: T
    
    init(_ value: T) {
        self.value = value
    }
}

public struct MemoryCache<K: AnyObject, V>: RandomAccessCache {
    public typealias Key = K
    public typealias Value = V
    
    private let storage = NSCache<Key, ValueHolder<V>>()
    
    public func value(for key: K) -> V? {
        return storage.object(forKey: key)?.value
    }
    
    public func set(_ value: Value?, for key: Key) {
        if let value = value {
            storage.setObject(ValueHolder(value), forKey: key)
        } else {
            storage.removeObject(forKey: key)
        }
    }
    
    public func clear() {
        storage.removeAllObjects()
    }
}
