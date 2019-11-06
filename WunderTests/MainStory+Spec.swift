//
//  MainStory+Spec.swift
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

class MainStorySpec: QuickSpec {
    
    override func spec() {
        
        describe("MainStory") {
            
            typealias SUT = MainStory
            
            var sut: SUT!
            
            var context: TestContext!
            
            var steps: RxHistory<StoryStep<MainStory.Screen>>!
            var screens: RxHistory<MainStory.Screen>!
            
            beforeEach {
                context = TestContext()
                sut = SUT(.init(context: context))
                steps = sut.storyStep.asObservable().history()
                screens = sut.screen.asObservable().history()
            }
            
            afterEach {
                context = nil
                sut = nil
                steps = nil
            }
            
            it("should be on main screen") {
                expect(steps.value.isReplaceAll).to(beTrue())
                expect(screens.value.main).toNot(beNil())
            }
            
            when("user taps map") {
                
                beforeEach {
                    screens.value.main.mapAction.execute()
                }
                
                it("should push to Map") {
                    expect(steps.value.isPush).to(beTrue())
                    expect(screens.value.map).toNot(beNil())
                }
                
                when("user taps back") {
                    
                    beforeEach {
                        screens.value.map.back.execute()
                    }
                    
                    it("should pop to main screen") {
                        expect(steps.value.isPop).to(beTrue())
                        expect(screens.value.main).toNot(beNil())
                    }
                    
                    when("user taps list") {
                        
                        beforeEach {
                            screens.value.main.listAction.execute()
                        }
                        
                        it("should push to List") {
                            expect(steps.value.isPush).to(beTrue())
                            expect(screens.value.list).toNot(beNil())
                        }
                        
                        when("user taps back") {
                            
                            beforeEach {
                                screens.value.list.back.execute()
                            }
                            
                            it("should pop to main screen") {
                                expect(steps.value.isPop).to(beTrue())
                                expect(screens.value.main).toNot(beNil())
                            }
                        }
                        
                        when("user taps item") {
                            
                            var items: RxHistory<[CarListItemViewModel]>!
                            
                            beforeEach {
                                items = screens.value.list.items.asObservable().history()
                                context._carsListEndpoint._apply.onNext(.success(CarsList(placemarks: [Car.mock()])))
                                items.value.first?.action.execute()
                            }
                            
                            afterEach {
                                items = nil
                            }
                            
                            it("should pop to main screen") {
                                expect(steps.value.isPush).to(beTrue())
                                expect(screens.value.map).toNot(beNil())
                            }
                        }
                    }
                }
            }
        }
    }
}

extension ActionViewModel {
    
    func execute() {
        tapped.onNext(Void())
    }
}

extension AttributedViewModel {
    
    func execute() {
        action.execute()
    }
}

extension StoryStep {
    
    var isPush: Bool! {
        switch self {
        case .push: return true
        case .pop, .popToRoot, .replaceAll: return false
        }
    }
    
    var isReplaceAll: Bool {
        switch self {
        case .replaceAll: return true
        case .pop, .popToRoot, .push: return false
        }
    }
    
    var isPop: Bool {
        switch self {
        case .pop: return true
        case .replaceAll, .popToRoot, .push: return false
        }
    }
    
    var isPopToRoot: Bool {
        switch self {
        case .popToRoot: return true
        case .replaceAll, .pop, .push: return false
        }
    }
}

extension MainStory.Screen {
    
    var main: MainScreen! {
        switch self {
        case let .main(screen): return screen
        case .list, .map: return nil
        }
    }
    
    var list: CarListScreen! {
        switch self {
        case let .list(screen): return screen
        case .main, .map: return nil
        }
    }
    
    var map: MapScreen! {
        switch self {
        case let .map(screen): return screen
        case .list, .main: return nil
        }
    }
}
