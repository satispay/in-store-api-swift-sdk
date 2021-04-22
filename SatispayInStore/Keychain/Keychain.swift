//
//  Keychain.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 03/10/16.
//  Copyright © 2016 Satispay. All rights reserved.
//

import Foundation
import Security

public class Keychain {

    /// Lock for keychain operations.
    private static var operationLock = NSLock()

    /// Keychain access group.
    public static var accessGroup: String?

    /// Private init
    private init() {
    }

    /// Executes the given block atomically in terms of keychain access.
    ///
    /// - parameter block: Block to run
    public static func performAtomically(block: () -> Void) {

        operationLock.lock()

        defer {
            operationLock.unlock()
        }

        block()

    }

    /// Deletes an item from the keychain.
    ///
    /// - parameter entry: Item to delete
    public static func delete(entry: KeychainEntry) {
        delete(descriptor: entry.descriptor)
    }

    /// Deletes an item from the keychain.
    ///
    /// - parameter entry: Item to delete
    public static func delete(descriptor: [String: Any]) {

        var searchDescriptor = descriptor
        #if os(iOS)
        searchDescriptor[String(kSecAttrAccessGroup)] = accessGroup
        searchDescriptor[String(kSecAttrAccessible)] = nil
        #endif

        performAtomically {
            SecItemDelete(searchDescriptor as CFDictionary)
        }

    }

    /// Inserts or replaces an item into the keychain.
    ///
    /// - parameter entry: Item to insert
    /// - parameter data: Data to insert
    ///
    /// - throws:
    ///
    ///   - `KeychainError.invalidData` in case `data` is not valid
    public static func insert(entry: PasswordEntry, data: Data) throws {

        guard !data.isEmpty else {
            throw KeychainError.invalidData
        }

        var status: OSStatus = errSecSuccess

        do {

            let _: Data = try find(entry: entry)

            var searchAttributes: [String: Any] = [
                kSecClass as String: entry.valueClass,
                kSecAttrService as String: entry.service,
                kSecAttrAccount as String: entry.account
            ]

            #if os(iOS)
            searchAttributes[String(kSecAttrAccessGroup)] = accessGroup
            #endif

            var updateAttributes: [String: Any] = [
                kSecValueData as String: data
            ]

            #if os(iOS)
            updateAttributes[String(kSecAttrAccessGroup)] = Keychain.accessGroup
            #endif

            #if os(macOS)
            if #available(macOS 10.15, *), Keychain.accessGroup != nil {
                updateAttributes[String(kSecAttrAccessGroup)] = Keychain.accessGroup
                updateAttributes[String(kSecUseDataProtectionKeychain)] = kCFBooleanTrue
            }
            #endif

            performAtomically {
                status = SecItemUpdate(searchAttributes as CFDictionary,
                                       updateAttributes as CFDictionary)
            }

        } catch KeychainError.notFound {

            var descriptor = entry.descriptor
            descriptor[kSecValueData as String] = data as AnyObject
            #if os(iOS)
            descriptor[String(kSecAttrAccessGroup)] = accessGroup
            #endif

            #if os(macOS)
            if Keychain.accessGroup != nil {
                descriptor[String(kSecAttrAccessGroup)] = Keychain.accessGroup
                descriptor[String(kSecUseDataProtectionKeychain)] = kCFBooleanTrue
            }
            #endif

            performAtomically {
                status = SecItemAdd(descriptor as CFDictionary, nil)
            }

            guard status == errSecSuccess else {
                throw KeychainError.failure(status)
            }

        }

    }

    /// Searches for an entry into the keychain.
    ///
    /// - parameter entry: Item to search for
    ///
    /// - throws:
    ///
    ///   - `KeychainError.notFound` if nothing is found for `entry`
    ///   - `KeychainError.failure` in case of any other error fetching the data
    ///
    /// - returns: Data
    @discardableResult
    public static func find(entry: PasswordEntry) throws -> Data {

        var descriptor = entry.descriptor
        descriptor[kSecMatchLimit as String] = kSecMatchLimitOne
        descriptor[kSecReturnData as String] = kCFBooleanTrue

        return try find(descriptor: descriptor) as! Data

    }

    /// Searches for an entry into the keychain given the descriptor dictionary.
    ///
    /// - parameter descriptor: Descriptor of the item to search for
    ///
    /// - throws:
    ///
    ///   - `KeychainError.notFound` if nothing is found for `entry`
    ///   - `KeychainError.failure` in case of any other error fetching the data
    ///
    /// - returns: Data
    @discardableResult
    public static func find(descriptor: [String: Any]) throws -> AnyObject? {

        var object: AnyObject?
        var status: OSStatus = errSecSuccess

        var searchDescriptor = descriptor
        if accessGroup != nil {
            searchDescriptor[String(kSecAttrAccessGroup)] = accessGroup
        }

        performAtomically {
            status = SecItemCopyMatching(searchDescriptor as CFDictionary, &object)
        }

        guard status == errSecSuccess, let result = object else {
            if status == errSecItemNotFound {
                throw KeychainError.notFound
            } else {
                throw KeychainError.failure(status)
            }
        }

        return result

    }

    /// Checks the `entry` exists in the keychain.
    ///
    /// - parameter entry: Entry to look for
    ///
    /// - returns: `true` if found, `false` otherwise
    public static func has(entry: PasswordEntry) -> Bool {

        var descriptor = entry.descriptor
        descriptor[kSecMatchLimit as String] = kSecMatchLimitOne
        descriptor[kSecReturnData as String] = kCFBooleanTrue

        do {
            _ = try find(descriptor: descriptor)
        } catch {
            return false
        }

        return true

    }

    /// Checks the `entry` exists in the keychain.
    ///
    /// - parameter entry: Entry to look for
    ///
    /// - returns: `true` if found, `false` otherwise
    public static func has(entry: KeyEntry) -> Bool {

        var descriptor = entry.descriptor
        descriptor[kSecMatchLimit as String] = kSecMatchLimitOne
        descriptor[kSecReturnData as String] = kCFBooleanTrue

        do {
            _ = try find(descriptor: descriptor)
        } catch {
            return false
        }

        return true

    }

}

extension Keychain {

    /// Keychain entry
    public struct PasswordEntry: KeychainEntry {

        public let valueClass = String(kSecClassGenericPassword)
        public let descriptor: [String: Any]

        public let service: String
        public let account: String

        public init(service: String, account: String) {

            self.service = service
            self.account = account

            self.descriptor = [
                String(kSecClass): valueClass,
                String(kSecAttrService): service,
                String(kSecAttrAccount): account
            ]

        }

    }

}
