//
//  DHController+PublicKey.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 10/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

extension DHController {

    /// Imports the public key to use to encrypt the DH challenge secret.
    public func importPublicKey() throws {

        guard let wallyPublicKey = Data(base64Encoded: SatispayInStoreConfig.environment.publicKey, options: .ignoreUnknownCharacters) else {
            throw DHError.cannotImportPublicKey
        }

        guard let strippedKey = Keychain.stripHeaderFromPublicKey(wallyPublicKey) else {
            throw DHError.cannotImportPublicKey
        }

        try Keychain.insert(entry: SatispayInStoreConfig.environment.keychain.publicKey, data: strippedKey)

    }

}
