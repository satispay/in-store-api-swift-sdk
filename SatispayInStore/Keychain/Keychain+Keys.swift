// swiftlint:disable force_cast

//
//  Keychain+Keys.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 17/10/16.
//  Copyright © 2016 Satispay. All rights reserved.
//

import Foundation

extension Keychain {

    /// Searches for a key into the keychain
    ///
    /// - parameter entry: Key to search for
    ///
    /// - throws:
    ///
    ///   - `KeychainError.notFound` if nothing is found for `entry`
    ///   - `KeychainError.failure` in case of any other error fetching the data
    ///
    /// - returns: Data
    @discardableResult
    public static func find(entry: KeyEntry) throws -> SecKey {

        var descriptor = entry.descriptor
        descriptor[kSecReturnRef as String] = kCFBooleanTrue

        return try find(descriptor: descriptor) as! SecKey

    }

    /// Inserts or replaces an RSA key into the keychain
    ///
    /// - parameter entry: Key to insert
    /// - parameter data: Data to insert
    ///
    /// - throws:
    ///
    ///   - `KeychainError.invalidData` in case `data` is not valid
    public static func insert(entry: KeyEntry, data: Data) throws {

        guard !data.isEmpty else {
            throw KeychainError.invalidData
        }

        delete(entry: entry)

        var status: OSStatus = errSecSuccess

        var descriptor = entry.descriptor
        descriptor[kSecAttrIsPermanent as String] = kCFBooleanTrue
        descriptor[kSecValueData as String] = data
        descriptor[kSecReturnPersistentRef as String] = kCFBooleanTrue
        descriptor[String(kSecAttrAccessGroup)] = accessGroup
        #if os(macOS)
        if #available(macOS 10.15, *) {
            descriptor[String(kSecUseDataProtectionKeychain)] = accessGroup != nil ? kCFBooleanTrue : kCFBooleanFalse
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

extension Keychain {

    public struct KeyEntry: KeychainEntry {

        public let valueClass = String(kSecClassKey)
        public let descriptor: [String: Any]

        public let keyType: String
        public let keyClass: String
        public let applicationTag: String

        public init(keyType: String = kSecAttrKeyTypeRSA as String,
                    keyClass: String = kSecAttrKeyClassPublic as String,
                    applicationTag: String) {

            self.keyType = keyType
            self.keyClass = keyClass
            self.applicationTag = applicationTag

            self.descriptor = [
                String(kSecClass): valueClass,
                String(kSecAttrKeyType): keyType,
                String(kSecAttrKeyClass): keyClass,
                String(kSecAttrApplicationTag): applicationTag.data(using: .utf8)!
            ]

        }

    }

}

extension Keychain {

    /**
     Strips the header from a public key in order to import it into the keychain.

     - parameter publicKey: Public key data

     - returns: Stripped key
     */
    public static func stripHeaderFromPublicKey(_ bytes: Data) -> Data? {

        guard bytes.count > 0 else {
            return nil
        }

        var index: Int = 0

        guard bytes[index] == 0x30 else {
            return nil
        }

        index += 1

        if bytes[index] > 0x80 {
            index += Int(bytes[index]) - 0x80 + 1
        } else {
            index += 1
        }

        //  szOID_RSA_RSA
        let szOID_RSA_RSA: [UInt8] = [0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01,
                                      0x01, 0x05, 0x00]

        let bounds = (lower: bytes.startIndex.advanced(by: index), upper: bytes.startIndex.advanced(by: index + 15))
        let certId = Array(bytes.subdata(in: Range(uncheckedBounds: bounds)))

        guard certId == szOID_RSA_RSA else {
            return nil
        }

        index += 15

        guard bytes[index] == 0x03 else {
            return nil
        }

        index += 1

        if bytes[index] > 0x80 {
            index += Int(bytes[index]) - 0x80 + 1
        } else {
            index += 1
        }

        guard bytes[index] == 0 else {
            return nil
        }

        index += 1

        return Data(bytes.suffix(from: index))

    }

}
