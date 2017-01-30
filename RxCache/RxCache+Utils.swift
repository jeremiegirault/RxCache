//
//  RxCache+Utils.swift
//  RxCache
//
//  Created by Jeremie Girault on 30/01/2017.
//  Copyright © 2017 Jeremie Girault. All rights reserved.
//

import RxSwift

extension Disposable {
    func addDisposableTo(_ compositeDisposable: CompositeDisposable) {
        _ = compositeDisposable.insert(self)
    }
} 
