//
//  APIError.swift
//  Wunder
//
//  Created by Dima Korolev on 05/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import Foundation

protocol EndpointErrorProtocol: Error {
    static func parse(code: Int) -> Self?
}

enum APIError<EndpointError: EndpointErrorProtocol>: Error {
    case codable(error: Error)
    case invalid(path: String)
    case service
    case badRequest
    case unauthorized
    case endpoint(EndpointError)
    
    static func parse(code: Int?) -> APIError<EndpointError> {
        switch code {
        case 401: return .unauthorized
        case 404: return .badRequest
        case let .some(code): return EndpointError.parse(code: code).map { .endpoint($0) } ?? .service
        case .none: return .service
        }
    }
}

enum GeneralAPIError: EndpointErrorProtocol {
    
    static func parse(code: Int) -> GeneralAPIError? {
        return nil
    }
}
