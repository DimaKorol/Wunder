//
//  Optional.swift
//  Wunder
//
//  Created by Dima Korolev on 05/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import Foundation

protocol OptionalProtocol {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalProtocol {
    
    var value: Wrapped? {
        switch self {
        case .none: return nil
        case let .some(value): return value
        }
    }
}

extension OptionalProtocol {
    
    func expectedValue(file: StaticString = #file, line: UInt = #line) -> Self {
        assert(self.value != nil, "Some value is expected \(file):\(line)")
        return self
    }
}
