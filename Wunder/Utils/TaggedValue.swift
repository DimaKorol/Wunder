//
//  TaggedValue.swift
//  Wunder
//
//  Created by Dima Korolev on 05/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import Foundation

// Phantom type to avoid mistakes on compiling time
// example: dropoff and pickup are coordinates but it have opposite meaning
public struct TaggedValue<Value, Tag> {
    public let value: Value
    public init(_ value: Value) { self.value = value }
}

extension TaggedValue: Equatable where Value: Equatable {}
extension TaggedValue: Hashable where Value: Hashable {}

extension TaggedValue: Decodable where Value: Decodable {
    
    public init(from decoder: Decoder) throws {
        do {
            try self.init(decoder.singleValueContainer().decode(Value.self))
        } catch {
            try self.init(Value(from: decoder))
        }
    }
}

extension TaggedValue: Encodable where Value: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}
