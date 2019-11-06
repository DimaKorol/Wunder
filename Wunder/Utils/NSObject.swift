//
//  NSObject.swift
//  Wunder
//
//  Created by Dima Korolev on 05/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import Foundation

extension NSObjectProtocol {
    
    func _lazyAssociatedObject<T>(
        _ key: UnsafeRawPointer,
        _ policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN,
        _ make: () -> T
    ) -> T {
        if let stored = objc_getAssociatedObject(self, key).flatMap({( $0 as? T).expectedValue() }) {
            return stored
        } else {
            let created = make()
            objc_setAssociatedObject(self, key, created, policy)
            return created
        }
    }
}
