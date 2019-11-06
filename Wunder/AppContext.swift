//
//  AppContext.swift
//  Wunder
//
//  Created by Dima Korolev on 05/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import Foundation

import RxSwift

typealias ContextProtocol = Any
    & CarsListEndpointContainer
    & SchedulerContainer
    & StringsServiceContainer


final class AppContext: ContextProtocol {
    
    let carsListEndpoint: CarsListEndpoint.Apply
    let scheduler: SchedulerType
    let strings: (Strings) -> String
    
    init() {
        scheduler = MainScheduler.instance
        
        let stringsService = StringsService()
        strings = stringsService.strings
        
        let urlSession = URLSession(configuration: .default)
        carsListEndpoint = CarsListEndpoint.make(with: urlSession)
    }
}
