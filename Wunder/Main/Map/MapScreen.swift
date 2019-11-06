//
//  MapScreen.swift
//  Wunder
//
//  Created by Dima Korolev on 05/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import UIKit
import MapKit

import RxSwift
import RxCocoa

struct MapCarItem: Equatable {
    let icon: UIImage
    let heading: Int
    let title: String
    let subtitle: String
    let coordinate: Coordinates
    let shouldFocus: Bool
}

protocol MapScreenViewModel {
    var back: ActionViewModel { get }
    var mapRegion: Driver<MKMapRect> { get }
    var items: Driver<[MapCarItem]> { get }
}

protocol MapScreenView: ViewProtocol where ViewModel == MapScreenViewModel {}

final class MapScreen: MapScreenViewModel {
    
    typealias Context = Any
        & CarsListEndpointContainer
        & SchedulerContainer
        & StringsServiceContainer
    
    struct Dependencies {
        let context: Context
        let focusCar: Car?
    }
    
    enum Result {
        case back
    }
    
    let back = ActionViewModel()
    
    let mapRegion: Driver<MKMapRect>
    
    let items: Driver<[MapCarItem]>
    
    let result: Observable<Result>
    
    private let dependencies: Dependencies
    
    init(_ dependencies: Dependencies) {
        self.dependencies = dependencies
        
        result = back.values.map { .back }
        
        let cars: Driver<[Car]>
        
        if let focusCar = dependencies.focusCar {
            cars = .just([focusCar])

            items = .just([MapCarItem(focusCar, strings: dependencies.context.strings, focus: true)])
        } else {
            cars = dependencies.context.carsListEndpoint(Void())
                .map { try? $0.get() }
                .ignoreNil()
                .map { $0.placemarks }
                .asDriver(onErrorJustReturn: [])
            
            items = cars.map { $0.map { MapCarItem($0, strings: dependencies.context.strings) } }
        }
        
        mapRegion = cars.filter { !$0.isEmpty }.map(makeRegion)
    }
}

private extension MapCarItem {
    
    init(_ car: Car, strings: (Strings) -> String, focus: Bool = false) {
        switch car.exterior.value {
        case .good:
            self.icon = Images.bundleImage(.goodCar)
        case .unacceptable:
            self.icon = Images.bundleImage(.unacceptableCar)
        case .unknown:
            self.icon = Images.bundleImage(.unknownCar)
        }
        self.heading = 0
        self.coordinate = car.coordinates
        self.title = car.name.value
        self.subtitle = String(format: strings(.mapItemFuel), "\(car.fuel.value)")
        self.shouldFocus = focus
    }
}

private func makeRegion(fits cars: [Car]) -> MKMapRect {
    var zoomRect = MKMapRect.null;
    for car in cars {
        let point = MKMapPoint(car.coordinates.toLocation())
        let pointRect = MKMapRect(x: point.x, y: point.y, width: 0.01, height: 0.01);
        zoomRect = zoomRect.union(pointRect);
    }
    return zoomRect
}
