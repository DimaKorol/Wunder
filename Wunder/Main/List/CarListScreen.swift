//
//  CarListScreen.swift
//  Wunder
//
//  Created by Dima Korolev on 05/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import RxCocoa
import RxSwift

protocol CarListScreenViewModel {
    var back: ActionViewModel { get }
    var items: Driver<[CarListItemViewModel]> { get }
}

protocol CarListScreenView: ViewProtocol where ViewModel == CarListScreenViewModel {}

final class CarListScreen: CarListScreenViewModel {
    
    typealias Context = Any
        & CarsListEndpointContainer
        & StringsServiceContainer
    
    struct Dependencies {
        let context: Context
    }
    
    enum Result {
        case showMap(Car)
        case back
    }
    
    let back = ActionViewModel()
    
    let items: Driver<[CarListItemViewModel]>
    
    let result: Observable<Result>
    
    private let dependencies: Dependencies
    private let _items: Observable<[CarListItem]>
    
    init(_ dependencies: Dependencies) {
        self.dependencies = dependencies
        
        self._items = dependencies.context.carsListEndpoint(Void())
            .map { try? $0.get() }
            .ignoreNil()
            .map { $0.placemarks }
            .map { $0.map { CarListItem(.init(car: $0)) } }
            .share(replay: 1, scope: .forever)
        
        self.items = _items.map { $0.map { $0 as CarListItemViewModel } }.asDriver(onErrorJustReturn: [])
        
        result = .merge(
            _items
                .asObservable()
                .map { $0.map { $0.result } }
                .flatMapLatest(Observable.merge)
                .map(Result.init),
            back.values.map { .back }
        )
    }
}

private extension CarListScreen.Result {
    
    init(_ result: CarListItem.Result) {
        switch result {
        case let .tapped(id): self = .showMap(id)
        }
    }
}
