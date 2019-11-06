//
//  MapScreen+Spec.swift
//  WunderTests
//
//  Created by Dima Korolev on 05/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import CoreLocation
import MapKit

import Nimble
import Quick

import RxSwift
import RxTest

@testable import Wunder

class MapScreenSpec: QuickSpec {
    
    override func spec() {
        
        describe("MapScreen") {
            
            typealias SUT = MapScreen
            
            var sut: SUT!
            
            var context: TestContext!

            var items: RxHistory<[MapCarItem]>!
            
            beforeEach {
                context = TestContext()
                sut = SUT(.init(context: context, focusCar: nil))
                items = sut.items.asObservable().history()
            }
            
            afterEach {
                context = nil
                sut = nil
                items = nil
            }
            
            it("should start request") {
                expect(context._carsListEndpoint.inputs.value.count) == 1
            }
            
            when("receive response") {
                
                let coordinates = Coordinates(latitude: Latitude(10), longitude: Longitude(10))
                
                let car = Car.mock(
                    coordinates: coordinates,
                    interior: CarInterior(.unacceptable)
                )
                
                beforeEach {
                    context._carsListEndpoint._apply.onNext(.success(CarsList(placemarks: [car])))
                }
                
                it("should produce items") {
                    expect(items.value) == [
                        MapCarItem(
                            icon: Images.bundleImage(.goodCar),
                            heading: 0,
                            title: car.name.value,
                            subtitle: "mapItemFuel",
                            coordinate: car.coordinates,
                            shouldFocus: false
                        )
                    ]
                }
            }
            
            
            when("user taps back") {
                
                var results: RxHistory<SUT.Result>!
                
                beforeEach {
                    results = sut.result.history()
                    sut.back.execute()
                }
                
                afterEach {
                    results = nil
                }
                
                it("should send result `back`") {
                    expect(results.value) == .back
                }
            }
        }
    }
}

extension Car {
    
    static func mock(
        vin: CarVIN = CarVIN("1"),
        name: CarName = CarName("Name"),
        fuel: CarFuel = CarFuel(2),
        coordinates: Coordinates = Coordinates(latitude: Latitude(0), longitude: Longitude(0)),
        engineType: CarEngineType = .ce,
        exterior: CarExterior = CarExterior(.good),
        interior: CarInterior = CarInterior(.good),
        address: Address = Address("Address")
    ) -> Car {
        return Car(
            vin: vin,
            name: name,
            fuel: fuel,
            coordinates: coordinates,
            engineType: engineType,
            exterior: exterior,
            interior: interior,
            address: address
        )
    }
}
