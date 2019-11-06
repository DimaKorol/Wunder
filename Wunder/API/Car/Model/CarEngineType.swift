//
//  CarEngineType.swift
//  Wunder
//
//  Created by Dima Korolev on 06/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import Foundation

enum CarEngineType: Decodable {
    
    init(from decoder: Decoder) throws {
        switch try decoder.singleValueContainer().decode(String.self) {
        case "CE": self = .ce
        case let unknown: self = .unknown(unknown)
        }
    }
    
    case ce
    case unknown(String)
}
