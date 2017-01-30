//
//  RandomAccessCache.swift
//  RxCache
//
//  Created by Jeremie Girault on 30/01/2017.
//  Copyright © 2017 Jeremie Girault. All rights reserved.
//

import Foundation
import RxSwift

/**
 * RandomAccessCache is a specialized version of Cache which provides synchronous querying semantic.
 */
public protocol RandomAccessCache: Cache {
    func value(for key: Key) -> Value?
}

//
// MARK: Default Implementation
//

extension RandomAccessCache { // : Cache
    public func observable(for key: Key) -> Observable<Value?> {
        return Observable.create { observer in
            observer.onNext(self.value(for: key))
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
}

//
// MARK: Helpers
//

extension RandomAccessCache {
    public subscript(key: Key) -> Value? {
        get { return value(for: key) }
        set { set(newValue, for: key) }
    }
}
