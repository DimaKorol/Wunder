//
//  MainStory.swift
//  Wunder
//
//  Created by Dima Korolev on 05/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol MainStoryViewModel {
    var storyStep: Driver<StoryStep<MainStory.Screen>> { get }
}

protocol MainStoryView: ViewProtocol where ViewModel == MainStoryViewModel {}

final class MainStory: MainStoryViewModel {
    
    typealias Context = Any
        & MapScreen.Context
        & MainScreen.Context
        & CarListScreen.Context
    
    struct Dependencies {
        let context: Context
    }
    
    enum Screen {
        case main(MainScreen)
        case list(CarListScreen)
        case map(MapScreen)
    }
    
    let storyStep: Driver<StoryStep<Screen>>
    
    var screen: Driver<Screen> {
        return story.screen
    }
    
    private let story: Story<Screen>
    private let disposeBag: DisposeBag
    private let dependencies: Dependencies
    
    init(_ dependencies: Dependencies) {
        self.dependencies = dependencies
        
        let disposeBag = DisposeBag()
        self.disposeBag = disposeBag
        
        func makeMain() -> Screen {
            return .main(MainScreen(.init(
                context: dependencies.context
            )))
        }
        
        func makeMap(focus: Car? = nil) -> Screen {
            return .map(MapScreen(.init(
                context: dependencies.context,
                focusCar: focus
            )))
        }
        
        func makeList() -> Screen {
            return .list(CarListScreen(.init(
                context: dependencies.context
            )))
        }
        
        self.story = Story(initial: makeMain())
        self.storyStep = self.story.step
        
        disposeBag.insert(
            self.story.screen
                .asObservable()
                .flatMapLatest { screen -> Observable<StoryStep<Screen>> in
                    switch screen {
                    case let .main(main):
                        return main.result.map {
                            switch $0 {
                            case .openList: return .push(makeList())
                            case .openMap: return .push(makeMap())
                            }
                        }
                        
                    case let .map(map):
                        return map.result.map {
                            switch $0 {
                            case .back: return .pop
                            }
                        }
                        
                    case let .list(list):
                        return list.result.map {
                            switch $0 {
                            case .back: return .pop
                            case let .showMap(car): return .push(makeMap(focus: car))
                            }
                        }
                    }
                }
                .subscribe(onNext: story.handle)
        )
    }
}
