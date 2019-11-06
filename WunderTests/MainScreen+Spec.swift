//
//  MainScreen+Spec.swift
//  WunderTests
//
//  Created by Dima Korolev on 05/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import Nimble
import Quick
import RxSwift
import RxTest

@testable import Wunder

class MainScreenSpec: QuickSpec {
    
    override func spec() {
        
        describe("MainScreen") {
            
            typealias SUT = MainScreen
            
            var sut: SUT!
            
            var context: TestContext!
            
            var results: RxHistory<SUT.Result>!
            
            beforeEach {
                context = TestContext()
                sut = SUT(.init(context: context))
                results = sut.result.history()
            }
            
            afterEach {
                context = nil
                sut = nil
                results = nil
            }
            
            when("user taps map") {
                
                beforeEach {
                    sut.mapAction.execute()
                }
                
                it("should send result `map`") {
                    expect(results.value) == .openMap
                }
            }
            
            when("user taps list") {
                
                beforeEach {
                    sut.listAction.execute()
                }
                
                it("should send result `map`") {
                    expect(results.value) == .openList
                }
            }
        }
    }
}

