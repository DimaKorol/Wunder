//
//  CarListItem.swift
//  Wunder
//
//  Created by Dima Korolev on 05/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import RxCocoa
import RxSwift

protocol CarListItemViewModel {
    var title: String { get }
    var details: String { get }
    var action: ActionViewModel { get }
}

protocol CarListItemView: ViewProtocol where ViewModel == CarListItemViewModel {}

final class CarListItem: CarListItemViewModel {
    
    struct Dependencies {
        let car: Car
    }
    
    enum Result {
        case tapped(Car)
    }
    
    let title: String
    let details: String
    let action = ActionViewModel()
    
    let result: Observable<Result>
    
    private let dependencies: Dependencies
    
    init(_ dependencies: Dependencies) {
        self.dependencies = dependencies
        
        title = String(format: "%@ (%@)", dependencies.car.name.value, dependencies.car.vin.value)
        details = dependencies.car.address.value
        
        result = action.values.map { .tapped(dependencies.car) }
    }
}
