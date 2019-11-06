//
//  Mutable.swift
//  Wunder
//
//  Created by Dima Korolev on 05/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import Foundation

public protocol Mutatable: class {}

public extension Mutatable {
    func mutate(_ closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
}

extension NSObject: Mutatable {}
