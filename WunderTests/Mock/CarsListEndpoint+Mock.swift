//
//  CarsListEndpoint+Mock.swift
//  WunderTests
//
//  Created by Dima Korolev on 05/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import RxSwift
import RxCocoa

@testable import Wunder

final class CarsListEndpointMock {
    
    let apply: CarsListEndpoint.Apply
    
    var inputs = BehaviorRelay<[CarsListEndpoint.Input]>(value: [])
    var _apply = PublishSubject<Result<CarsListEndpoint.Output, APIError<CarsListEndpoint.Error>>>()
    
    var input: CarsListEndpoint.Input! {
        return inputs.value.last
    }
    
    init() {
        apply = { [inputs, _apply] in
            inputs.accept(inputs.value + [$0])
            return _apply
        }
    }
}
