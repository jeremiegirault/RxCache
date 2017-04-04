//
//  Cache.swift
//  openrider
//
//  Created by Jeremie Girault on 21/03/2017.
//  Copyright © 2017 EC1. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/// The storage backend of a cache
public struct CacheStorage<E> {
    public typealias Get = (AnyHashable) -> Single<E?>
    public typealias Put = (E, AnyHashable) -> Void
    
    private let _get: Get
    private let _put: Put
    
    public init(get: @escaping Get, put: @escaping Put) {
        _get = get
        _put = put
    }
    
    // Gets a value from the cache. The contract is: 
    // - never error
    // - return nil value is absent from the cache storage for the given key
    // - return the value if cached in storage for key
    // - thread-safe and if possible serialized with `put`
    public func get(key: AnyHashable) -> Single<E?> {
        return _get(key)
    }
    
    // puts a value in the cache asynchronously
    // - The caller can't know when or if the value was actually stored
    // - It is more natural to use write barriers so that the caller expects a natural order when using the cache
    // But it is not guaranteed
    public func put(_ value: E, forKey key: AnyHashable) {
        return _put(value, key)
    }
    
    // TODO: operator: mapKeys, mapValues (bi-directional)
}


public final class Cache<E> {
    
    private let serialQueue: DispatchQueue
    private var queryReusePool = [AnyHashable: Observable<E>]()
    private let storage: CacheStorage<E>
    private let identifier: String
    
    public init(name: String, storage: CacheStorage<E>) {
        self.identifier = "Cache:\(name)"
        self.storage = storage
        serialQueue = DispatchQueue(label: identifier)
    }
    
    private func createReusableQuery(forKey key: AnyHashable, or fallback: Observable<E>) -> Observable<E> {
        return self.storage.get(key: key) // query the storage
            .asObservable()
            .flatMap { cachedValue -> Observable<E> in
                
                // if the cache storage provides a value, just use it
                if let cachedValue = cachedValue {
                    return .just(cachedValue)
                }
                
                // else query the original observer
                // + when the original observer returns a value, feed the storage
                return fallback
                    .take(1)
                    .do(onNext: { value in
                        self.storage.put(value, forKey: key)
                    })
            }
            .do(onDispose: { self.serialQueue.async { self.queryReusePool[key] = nil } }) // when the query completes, remove it from reuse pool
            .shareReplay(1)
    }
    
    // - Note1: There is a limitation here: the key should be hashable. Actually we could improve to remove the conformance.
    // There is cases where no hash do not cause perf loss (e.g. indexes like B-trees)
    // - Note2: is observable ok ? The contract of a CacheStorage should be: a single value without any error.
    // But the fallback observable could send an error.
    public func query(_ key: AnyHashable, or fallback: Observable<E>) -> Observable<E> {
        return Observable<E>.create { observer in
            
            let compositeDisposable = CompositeDisposable()
            
            self.serialQueue.async {
                // just a small optimization avoiding to touch the reuse pool
                // if the observer is disposed before even checking the reuse pool
                guard !compositeDisposable.isDisposed else { return }
                
                // reuse an existing query if possible
                let query: Observable<E>
                if let existingQuery = self.queryReusePool[key] { // a query is stored => reuse
                    query = existingQuery
                } else { // create a query and make it reusable for cache clients
                    query = self.createReusableQuery(forKey: key, or: fallback)
                    self.queryReusePool[key] = query
                }
                // should subscription start on some client provided queue ?
                _ = compositeDisposable.insert(query.subscribe(observer))
            }
            
            return compositeDisposable
        }
    }
}
