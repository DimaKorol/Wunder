//
//  EndpointMethod.swift
//  Wunder
//
//  Created by Dima Korolev on 05/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import Foundation

enum EndpointMethod {
    case get
    case post(Data)
}

protocol EndpointMethodProtocol {
    associatedtype Input
    func encode(input: Input, using encoder: EncoderProtocol) throws -> EndpointMethod
}

struct EndpointGetMethod<Input>: EndpointMethodProtocol {
    
    func encode(input: Input, using encoder: EncoderProtocol) throws -> EndpointMethod {
        return .get
    }
}

extension EndpointMethod {
    
    var httpMethod: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        }
    }
}
