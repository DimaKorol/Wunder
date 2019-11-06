//
//  QuickUtils.swift
//  WunderTests
//
//  Created by Dima Korolev on 05/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import Quick

public func when(_ description: String, flags: FilterFlags = [:], closure: () -> ()) {
    describe("WHEN \(description)", flags: flags, closure: closure)
}

public func xwhen(_ description: String, flags: FilterFlags = [:], closure: () -> ()) {
    xdescribe("WHEN \(description)", flags: flags, closure: closure)
}

public func fwhen(_ description: String, flags: FilterFlags = [:], closure: () -> ()) {
    fdescribe("WHEN \(description)", flags: flags, closure: closure)
}

public func and(_ description: String, flags: FilterFlags = [:], closure: () -> ()) {
    describe("AND \(description)", flags: flags, closure: closure)
}

public func xand(_ description: String, flags: FilterFlags = [:], closure: () -> ()) {
    xdescribe("AND \(description)", flags: flags, closure: closure)
}

public func fand(_ description: String, flags: FilterFlags = [:], closure: () -> ()) {
    fdescribe("AND \(description)", flags: flags, closure: closure)
}
