//
//  Cache+Map.swift
//  RxCache
//
//  Created by Jeremie Girault on 30/01/2017.
//  Copyright © 2017 Jeremie Girault. All rights reserved.
//

import RxSwift

extension Cache {
    public func mapValues<U>(transform: @escaping (U) -> Value, reverseTransform: @escaping (Value) -> U) -> AnyCache<Key, U> {
        return AnyCache<Key, U>(
            get: { self.observable(for: $0).map { $0.map(reverseTransform) } },
            set: { self.set($0.map(transform), for: $1) },
            clear: { self.clear() })
    }
    
    public func mapKeys<U>(_ keyMapping: @escaping (U) -> Key) -> AnyCache<U, Value> {
        return AnyCache(
            get: { self.observable(for: keyMapping($0)) },
            set: { self.set($0, for: keyMapping($1)) },
            clear: { self.clear() })
    }
}
