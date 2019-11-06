//
//  MapScreen+View.swift
//  Wunder
//
//  Created by Dima Korolev on 05/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa

private let mapInsets = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)

final class MapScreenViewController: UIViewController {
    
    private let topBar = TopBarView().mutate {
        $0.title.text = Strings.localized(.mapScreenTitle)
    }
    
    private let mapView = MKMapView()
    
    private var items: [String: MapCarItem] = [:]
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        focusOnCarIfNeeded()
    }
    
    private func setup() {
        self.view.backgroundColor = .white
        
        mapView.delegate = self
        
        [mapView, topBar].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: view.topAnchor),
            topBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            topBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            mapView.topAnchor.constraint(equalTo: topBar.bottomAnchor),
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func focusOnCarIfNeeded() {
        items.first { $0.value.shouldFocus }
            .flatMap { key, _ in mapView.annotations.first { $0.identifier == key } }
            .map { mapView.selectAnnotation($0, animated: true) }
    }
}

extension MapScreenViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = MKAnnotationView.reuseIdentifier
        
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        guard let car = items[annotation.identifier] else {
            return nil
        }
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            ?? MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        
        annotationView.canShowCallout = true
        annotationView.image = car.icon
        annotationView.transform = CGAffineTransform(rotationAngle: CGFloat(car.heading))
        
        return annotationView
    }
}

extension MapScreenViewController: MapScreenView {
    
    func bind(_ viewModel: MapScreenViewModel) -> Disposable {
        let disposable = CompositeDisposable()
        _ = disposable.insert(topBar.backButton.bind(viewModel.back))
        _ = disposable.insert(viewModel.mapRegion.drive(onNext: { [weak mapView] region in
            guard let mapView = mapView.expectedValue() else { return }
            mapView.setVisibleMapRect(region, edgePadding: mapInsets, animated: mapView.window != nil)
        }))
        _ = disposable.insert(viewModel.items.drive(onNext: setCars))
        return disposable
    }
    
    private func setCars(_ cars: [MapCarItem]) {
        items = [:]
        mapView.removeAnnotations(mapView.annotations.filter { !($0 is MKUserLocation) })
        let annotationCarItems = cars.map { car in
            (
                annotation: MKPointAnnotation().mutate {
                    $0.coordinate = car.coordinate.toLocation()
                    $0.title = car.title
                    $0.subtitle = car.subtitle
                },
                car: car
            )
        }
        annotationCarItems.forEach {
            items[$0.annotation.identifier] = $0.car
        }
        mapView.addAnnotations(annotationCarItems.map { $0.0 })
    }
}

private var identifierKey = ""
private extension NSObjectProtocol {
    
    var identifier: String {
        return _lazyAssociatedObject(&identifierKey) { UUID().uuidString }
    }
}

extension MKAnnotationView: Reusable {}
