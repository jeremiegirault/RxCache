//
//  Observable+Cache.swift
//  RxCache
//
//  Created by Jeremie Girault on 30/01/2017.
//  Copyright © 2017 Jeremie Girault. All rights reserved.
//

import RxSwift

extension ObservableType {
    public func cached<Key: Hashable>(in cache: Cache<E>, forKey key: Key) -> Observable<E> {
        return cache.query(key, or: self.asObservable())
    }
}

extension PrimitiveSequenceType {
    public func cached<Key: Hashable>(in cache: Cache<ElementType>, forKey key: Key) -> Observable<ElementType> {
        return cache.query(key, or: self.primitiveSequence.asObservable())
    }
}
