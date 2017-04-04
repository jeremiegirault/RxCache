//
//  RxCacheTests.swift
//  RxCache
//
//  Created by Florent Pillet on 18/10/16.
//  Copyright (c) 2016 RxSwiftCommunity https://github.com/RxSwiftCommunity
//

import Quick
import Nimble
import RxSwift
@testable import RxCache

class RxCacheTests: QuickSpec {
    override func spec() {
        var disposeBag: DisposeBag!

        beforeEach {
            disposeBag = DisposeBag()
        }
        
        afterEach {
            disposeBag = nil
        }
        
        it("perform some tests") {
            expect(true).to(beTrue())
        }
    }
}
