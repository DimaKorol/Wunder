//
//  Images.swift
//  Wunder
//
//  Created by Dima Korolev on 05/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import UIKit

final class Images: NSObject {
    
    private let name: String
    
    private static let bundle = Bundle.init(identifier: "IMAGES")
    
    private init(_ name: String) {
        self.name = name
    }
    
    @objc static func bundleImage(_ image: Images) -> UIImage {
        return UIImage(named: image.name).expectedValue() ?? UIImage()
    }
    
    @objc static func templateImage(_ image: Images) -> UIImage {
        return bundleImage(image).withRenderingMode(.alwaysTemplate)
    }
}

// Should be generated by some script (SwiftGen etc.)
extension Images {
    
    @objc static var directionArrow = Images("directionArrow")
    @objc static var backArrow = Images("backArrow")
    @objc static var goodCar = Images("goodCar")
    @objc static var unacceptableCar = Images("unacceptableCar")
    @objc static var unknownCar = Images("unknownCar")
    @objc static var mainPlaceholder = Images("mainPlaceholder")
    @objc static var viewInList = Images("viewInList")
    @objc static var viewOnMap = Images("viewOnMap")
}
