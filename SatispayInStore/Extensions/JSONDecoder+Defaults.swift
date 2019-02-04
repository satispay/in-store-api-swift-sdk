//
//  JSONDecoder+Defaults.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

extension JSONDecoder {

    /// ISO8601 date formatter.
    private static let formatter: DateFormatter = {

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        return formatter

    }()

    /// Returns a `JSONDecoder` that uses the `ISO8601` as date decoding strategy.
    ///
    /// - Returns: JSON decoder
    static func decoder() -> JSONDecoder {

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)

        return decoder

    }

    /// Returns a value decoded from its JSON representation.
    ///
    /// - Parameter type: Type of the value to decode
    /// - Parameter type: JSON representation
    /// - Returns: Decoded value
    /// - Throws: Anything thrown by the `decode` instance method
    static func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        return try decoder().decode(type, from: data)
    }

}
