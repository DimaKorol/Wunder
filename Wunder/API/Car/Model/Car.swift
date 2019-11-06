//
//  Car.swift
//  Wunder
//
//  Created by Dima Korolev on 06/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import Foundation

enum CarVINTag {}
typealias CarVIN = TaggedValue<String, CarVINTag>

enum AddressTag {}
typealias Address = TaggedValue<String, AddressTag>

enum CarFuelTag {}
typealias CarFuel = TaggedValue<Int, CarFuelTag>

enum CarNameTag {}
typealias CarName = TaggedValue<String, CarNameTag>

enum CarInteriorTag {}
typealias CarInterior = TaggedValue<CarConditionType, CarInteriorTag>

enum CarExteriorTag {}
typealias CarExterior = TaggedValue<CarConditionType, CarExteriorTag>

struct Car: Decodable {
    let vin: CarVIN
    let name: CarName
    let fuel: CarFuel
    let coordinates: Coordinates
    let engineType: CarEngineType
    let exterior: CarExterior
    let interior: CarInterior
    let address: Address
}
