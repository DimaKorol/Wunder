//
//  CarsListEndpoint.swift
//  Wunder
//
//  Created by Dima Korolev on 06/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import Foundation

protocol CarsListEndpointContainer {
    var carsListEndpoint: CarsListEndpoint.Apply { get }
}

final class CarsListEndpoint: EndpointProtocol {
    
    typealias Output = CarsList
    
    typealias Error = GeneralAPIError
    
    typealias Input = Void
    
    static var path: (Input) -> String {
        return { _ in "https://wunder-test-case.s3-eu-west-1.amazonaws.com/ios/locations.json" }
    }
    
    static var headers: (Input) -> [String : String] {
        return { _ in [:] }
    }
    
    static var method: EndpointGetMethod<Input> {
        return EndpointGetMethod()
    }
}
