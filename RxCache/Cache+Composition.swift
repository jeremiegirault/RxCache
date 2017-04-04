//
//  Cache+Composition.swift
//  openrider
//
//  Created by Jeremie Girault on 04/04/2017.
//  Copyright © 2017 EC1. All rights reserved.
//

import Foundation

extension CacheStorage {
    public func fallbackTo(_ other: CacheStorage) -> CacheStorage {
        return CacheStorage(
            get: { key in
                // query this cache (=nearest)
                return self.get(key: key)
                    .flatMap { cachedValue in
                        // if the value is cached in the front cache, just return this value
                        if let cachedValue = cachedValue { return .just(cachedValue) }
                        // else fetch the value from the fallback cache
                        return other.get(key: key)
                            .do(onNext: { cachedValue in
                                // as a side effect, if the fallback cache provides a value, move it to the nearest cache
                                if let cachedValue = cachedValue {
                                    self.put(cachedValue, forKey: key)
                                }
                            })
                    }
            },
            put: { value, key in
                self.put(value, forKey: key)
                other.put(value, forKey: key)
            })
    }
}

