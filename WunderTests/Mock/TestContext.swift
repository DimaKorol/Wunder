//
//  TestContext.swift
//  WunderTests
//
//  Created by Dima Korolev on 05/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import RxSwift
import RxTest

@testable import Wunder

class TestContext: ContextProtocol {
    
    var carsListEndpoint: CarsListEndpoint.Apply {
        return _carsListEndpoint.apply
    }
    
    var scheduler: SchedulerType {
        return _scheduler
    }
    
    let strings: (Strings) -> String
    
    let _scheduler = HistoricalScheduler()
    let _carsListEndpoint = CarsListEndpointMock()
    
    init() {
        strings = { "\($0)" }
    }
}
