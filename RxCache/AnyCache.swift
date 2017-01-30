//
//  AnyCache.swift
//  RxCache
//
//  Created by Jeremie Girault on 30/01/2017.
//  Copyright © 2017 Jeremie Girault. All rights reserved.
//

import RxSwift

/**
 * A type-erased wrapper over any Cache
 */
public struct AnyCache<K, V>: Cache {
    public typealias Key = K
    public typealias Value = V
    
    public typealias Get = (Key) -> Observable<Value?>
    public typealias Set = (Value?, Key) -> Void
    public typealias Clear = () -> Void
    
    private let _get: Get
    private let _set: Set
    private let _clear: Clear
    
    public init(get: @escaping Get, set: @escaping Set, clear: @escaping Clear) {
        _get = get
        _set = set
        _clear = clear
    }
    
    public init<C: Cache>(_ cache: C) where C.Key == Key, C.Value == Value {
        _get = { cache.observable(for: $0) }
        _set = { cache.set($0, for: $1) }
        _clear = { cache.clear() }
    }
    
    public func observable(for key: K) -> Observable<V?> {
        return _get(key)
    }
    
    public func set(_ value: V?, for key: K) {
        _set(value, key)
    }
    
    public func clear() {
        _clear()
    }
}
