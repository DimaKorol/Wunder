//
//  Codable.swift
//  Wunder
//
//  Created by Dima Korolev on 05/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import Foundation

protocol EncoderProtocol {
    func encode<T>(_ value: T) throws -> Data where T: Encodable
}

protocol DecoderProtocol {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}

extension JSONEncoder: EncoderProtocol {
    
    static let `default` = JSONEncoder()
}
extension JSONDecoder: DecoderProtocol {
    
    static let `default` = JSONDecoder()
}
