//
//  CarsList.swift
//  Wunder
//
//  Created by Dima Korolev on 06/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import Foundation

struct CarsList: Decodable {
    let placemarks: [Car]
}
