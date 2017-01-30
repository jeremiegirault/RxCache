//
//  Observable+Cache.swift
//  RxCache
//
//  Created by Jeremie Girault on 30/01/2017.
//  Copyright © 2017 Jeremie Girault. All rights reserved.
//

import RxSwift

public extension Observable {
    
    /**
     Put a cache in front of a stream of value.
     It is your role to create and configure a cache. Then you can create a caching layer :
     
     fetchHttp(url)
        .heavyComputation()
        .cached(myCache, url) <- result of the computation will be cached according to the cache configuration
        .continue()
     
     Current Observable is assumed to be cold.
     */
    func cached<C: Cache>(_ cache: C, for key: C.Key) -> Observable<E> where C.Value == E {
        return Observable.create { observer in
            let disposable = CompositeDisposable()
            cache.observable(for: key)
                .subscribe(onNext: { result in
                    if let result = result { // was the value in cache ?
                        observer.onNext(result)
                        observer.onCompleted()
                    } else { // query the original observable
                        self.take(1)
                            .do(onNext: { first in
                                cache.set(first, for: key)
                            })
                            .subscribe(observer)
                            .addDisposableTo(disposable)
                    }
                })
                .addDisposableTo(disposable)
            
            return disposable
        }
    }
}
