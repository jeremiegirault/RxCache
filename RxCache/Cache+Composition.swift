//
//  Cache+Composition.swift
//  RxCache
//
//  Created by Jeremie Girault on 30/01/2017.
//  Copyright © 2017 Jeremie Girault. All rights reserved.
//

import RxSwift

extension Cache {
    
    public func compose<C: Cache>(_ next: C) -> AnyCache<Key, Value> where Key == C.Key, Value == C.Value {
        return AnyCache(
            get: { key in
                self.observable(for: key)
                    .flatMapLatest { (result: Value?) -> Observable<Value?> in
                        if let result = result { // if we have a result in this layer, use it
                            return .just(result)
                        } else { // use the next cache layer
                            return next.observable(for: key)
                                .do(onNext: { value in // update this layer with the value from next layer if any
                                    if let value = value {
                                        self.set(value, for: key)
                                    }
                                })
                        }
                    }
            },
            set: { value, key in
                self.set(value, for: key)
                next.set(value, for: key)
            },
            clear: {
                self.clear()
                next.clear()
            })
    }

}
