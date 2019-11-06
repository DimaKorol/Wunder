//
//  MainScreen.swift
//  Wunder
//
//  Created by Dima Korolev on 05/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import RxCocoa
import RxSwift

protocol MainScreenViewModel {
    var mapAction: AttributedViewModel { get }
    var listAction: AttributedViewModel { get }
}

protocol MainScreenView: ViewProtocol where ViewModel == MainScreenViewModel {}

final class MainScreen: MainScreenViewModel {
    
    typealias Context = Any
        & StringsServiceContainer
    
    struct Dependencies {
        let context: Context
    }
    
    enum Result {
        case openList
        case openMap
    }
    
    let mapAction: AttributedViewModel
    var listAction: AttributedViewModel
    
    let result: Observable<Result>
    
    private let dependencies: Dependencies
    
    init(_ dependencies: Dependencies) {
        self.dependencies = dependencies
        
        mapAction = AttributedViewModel(
            title: dependencies.context.strings(.mainScreenMapButton),
            image: Images.templateImage(.viewOnMap)
        )
        
        listAction = AttributedViewModel(
            title: dependencies.context.strings(.mainScreenListButton),
            image: Images.templateImage(.viewInList)
        )
        
        result = .merge(
            listAction.action.values.map { .openList },
            mapAction.action.values.map { .openMap }
        )
    }
}
