//
//  Keychain+Overloads.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 17/10/16.
//  Copyright © 2016 Satispay. All rights reserved.
//

import Foundation

extension Keychain {

    /// Searches for an entry into the keychain
    ///
    /// - parameter entry: Item to search for
    ///
    /// - throws:
    ///
    ///   - `KeychainError.notFound` if nothing is found for `entry`
    ///   - `KeychainError.failure` in case of any other error fetching the data
    ///
    /// - returns: String
    @discardableResult
    public static func find(entry: PasswordEntry) throws -> String {

        let data: Data = try find(entry: entry)

        if let string = String(data: data, encoding: .utf8) {
            return string
        } else if let archive = NSKeyedUnarchiver.unarchiveObject(with: data) as? NSString {
            return String(archive)
        }

        throw KeychainError.invalidData

    }

    /// Searches for an entry into the keychain
    ///
    /// - parameter entry: Item to search for
    ///
    /// - throws:
    ///
    ///   - `KeychainError.notFound` if nothing is found for `entry`
    ///   - `KeychainError.failure` in case of any other error fetching the data
    ///
    /// - returns: Int
    @discardableResult
    public static func find(entry: PasswordEntry) throws -> Int {

        let data: Data = try find(entry: entry)

        if let string = String(data: data, encoding: .utf8), let value = Int(string) {
            return value
        } else if let archive = NSKeyedUnarchiver.unarchiveObject(with: data) as? NSNumber {
            return archive.intValue
        }

        throw KeychainError.invalidData

    }

    /// Searches for an entry into the keychain
    ///
    /// - parameter entry: Item to search for
    ///
    /// - throws:
    ///
    ///   - `KeychainError.notFound` if nothing is found for `entry`
    ///   - `KeychainError.failure` in case of any other error fetching the data
    ///
    /// - returns: Int
    @discardableResult
    public static func find<Value: LosslessStringConvertible>(entry: PasswordEntry) throws -> Value {

        let data: Data = try find(entry: entry)

        guard let string = String(data: data, encoding: .utf8), let value = Value(string) else {
            throw KeychainError.invalidData
        }

        return value

    }

    /// Inserts or replaces an item into the keychain
    ///
    /// - parameter entry: Item to insert
    /// - parameter value: Value to insert
    ///
    /// - throws:
    ///
    ///   - `KeychainError.invalidData` in case `value` is not valid
    public static func insert(entry: PasswordEntry, value: String) throws {

        guard let data = value.data(using: .utf8) else {
            throw KeychainError.invalidData
        }

        try insert(entry: entry, data: data)

    }

    /// Inserts or replaces an item into the keychain
    ///
    /// - parameter entry: Item to insert
    /// - parameter value: Value to insert
    ///
    /// - throws:
    ///
    ///   - `KeychainError.invalidData` in case `value` is not valid
    public static func insert(entry: PasswordEntry, value: Int) throws {

        try insert(entry: entry, value: String(value))

    }

    /// Inserts or replaces an item into the keychain
    ///
    /// - parameter entry: Item to insert
    /// - parameter value: Value to insert
    ///
    /// - throws:
    ///
    ///   - `KeychainError.invalidData` in case `value` is not valid
    public static func insert<Value: LosslessStringConvertible>(entry: PasswordEntry, value: Value) throws {

        try insert(entry: entry, value: String(value))

    }

}
