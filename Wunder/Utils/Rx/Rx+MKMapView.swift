//
//  Rx+MKMapView.swift
//  Wunder
//
//  Created by Dima Korolev on 05/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import MapKit
import RxSwift
import RxCocoa

extension MKMapView: HasDelegate {
    public typealias Delegate = MKMapViewDelegate
}

class RxMKMapViewDelegateProxy: DelegateProxy<MKMapView, MKMapViewDelegate>, DelegateProxyType, MKMapViewDelegate {
    
    static func registerKnownImplementations() {
        self.register {
            return RxMKMapViewDelegateProxy(parentObject: $0, delegateProxy: RxMKMapViewDelegateProxy.self)
        }
    }
    
    static func currentDelegate(for object: MKMapView) -> MKMapViewDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: MKMapViewDelegate?, to object: MKMapView) {
        object.delegate = delegate
    }
}

extension Reactive where Base: MKMapView {
    
    var delegate: RxMKMapViewDelegateProxy {
        return RxMKMapViewDelegateProxy.proxy(for: base)
    }
    
    var didChangeVisibleRegion: Observable<MKCoordinateRegion> {
        return delegate
            .methodInvoked(#selector(MKMapViewDelegate.mapView(_:regionDidChangeAnimated:)))
            .map { ($0[0] as? MKMapView)?.region }
            .ignoreNil()
    }
}
