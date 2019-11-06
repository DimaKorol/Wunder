//
//  Coordinate.swift
//  Wunder
//
//  Created by Dima Korolev on 06/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import Foundation
import CoreLocation

enum LatitudeTag {}
typealias Latitude = TaggedValue<Double, LatitudeTag>

enum LongitudeTag {}
typealias Longitude = TaggedValue<Double, LongitudeTag>

struct Coordinates: Decodable, Equatable {
    let latitude: Latitude
    let longitude: Longitude
    
    init(
        latitude: Latitude,
        longitude: Longitude
    ) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let coordinates = try container.decode([Double].self)
        guard
            let latitude = coordinates[safe: 1],
            let longitude = coordinates[safe: 0]
        else { throw DecodingError.dataCorruptedError(in: container, debugDescription: "incorrect array") }
        
        self.latitude = Latitude(latitude)
        self.longitude = Longitude(longitude)
    }
}

extension Coordinates {
    
    init(_ location: CLLocationCoordinate2D) {
        self.latitude = Latitude(location.latitude)
        self.longitude = Longitude(location.longitude)
    }
    
    func toLocation() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude.value, longitude: longitude.value)
    }
}
