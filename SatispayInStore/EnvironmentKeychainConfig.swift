//
//  EnvironmentKeychainConfig.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 20/11/17.
//  Copyright © 2017 Pierluigi D'Andrea. All rights reserved.
//

import Foundation

/// Keychain entries configuration
public struct EnvironmentKeychainConfig {

    /// Keychain entry for the DH public key.
    public let publicKey: Keychain.KeyEntry

    /// Keychain entry for the secret key shared with the server.
    public let kSafe: Keychain.PasswordEntry

    /// Keychain entry for the DH shared secret.
    public let kMaster: Keychain.PasswordEntry

    /// Keychain entry for the user id.
    public let keyId: Keychain.PasswordEntry

    /// Keychain entry for the sequence number of the last request received.
    public let sequenceNumber: Keychain.PasswordEntry

    /// Whether the keychain contains all the keys needed to send secure requests to the server.
    public var containsData: Bool {

        return Keychain.has(entry: kSafe)
            && Keychain.has(entry: kMaster)
            && Keychain.has(entry: keyId)
            && Keychain.has(entry: sequenceNumber)

    }

    /// New keychain configuration.
    public init(publicKey: Keychain.KeyEntry,
                kSafe: Keychain.PasswordEntry,
                kMaster: Keychain.PasswordEntry,
                keyId: Keychain.PasswordEntry,
                sequenceNumber: Keychain.PasswordEntry) {

        self.publicKey = publicKey

        self.kSafe = kSafe
        self.kMaster = kMaster
        self.keyId = keyId
        self.sequenceNumber = sequenceNumber

    }

    /// Deletes all the entries, except `publicKey`, from the keychain.
    public func clear() {

        Keychain.delete(entry: SatispayInStoreConfig.environment.keychain.kSafe)
        Keychain.delete(entry: SatispayInStoreConfig.environment.keychain.kMaster)
        Keychain.delete(entry: SatispayInStoreConfig.environment.keychain.keyId)
        Keychain.delete(entry: SatispayInStoreConfig.environment.keychain.sequenceNumber)

    }

}
