//
//  MemCache.swift
//  openrider
//
//  Created by Jeremie Girault on 21/03/2017.
//  Copyright © 2017 EC1. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

private final class MemCacheKey: NSObject {
    let hashable: AnyHashable
    
    init(_ hashable: AnyHashable) { self.hashable = hashable }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? MemCacheKey else { return false }
        return hashable == other.hashable
    }
    
    override var hash: Int { return hashable.hashValue }
}

private final class MemCacheValue {
    let value: Any
    
    init(_ value: Any) { self.value = value }
}

///
/// A simple In-Memory NSCache backed cache storage
///
extension CacheStorage {
    
    public static func inMemory<E>() -> CacheStorage<E> {
        let memcache = NSCache<MemCacheKey, MemCacheValue>()
        return CacheStorage<E>(
            get: { (key) -> Single<E?> in
                return Single<E?>.create { observer in
                    let storedValue = memcache.object(forKey: MemCacheKey(key))
                    observer(.success(storedValue?.value as? E))
                    return Disposables.create()
                }
        },
            put: { (value, key) in
                memcache.setObject(MemCacheValue(value), forKey: MemCacheKey(key))
        })
    }
    
}

