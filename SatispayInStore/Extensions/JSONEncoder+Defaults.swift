//
//  JSONDecoder+Defaults.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

extension JSONEncoder {

    /// ISO8601 date formatter.
    private static let formatter: DateFormatter = {

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        return formatter

    }()

    /// Returns a `JSONEncoder` that uses the `ISO8601` as date decoding strategy.
    ///
    /// - Returns: JSON encoder
    static func encoder() -> JSONEncoder {

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(formatter)

        return encoder

    }

    /// Returns a JSON-encoded representation of `value`.
    ///
    /// - Parameter value: Value to encode
    /// - Returns: Data representation
    /// - Throws: Anything thrown by the `encode` instance method
    static func encode<T>(_ value: T) throws -> Data where T: Encodable {
        return try encoder().encode(value)
    }

}
