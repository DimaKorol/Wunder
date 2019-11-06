//
//  CarConditionType.swift
//  Wunder
//
//  Created by Dima Korolev on 06/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import Foundation

enum CarConditionType: Decodable {
    
    init(from decoder: Decoder) throws {
        switch try decoder.singleValueContainer().decode(String.self) {
        case "UNACCEPTABLE": self = .unacceptable
        case "GOOD": self = .good
        case let unknown: self = .unknown(unknown)
        }
    }
    
    case unacceptable
    case good
    case unknown(String)
}
