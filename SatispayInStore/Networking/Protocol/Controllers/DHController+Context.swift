//
//  DHController+Context.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/11/17.
//  Copyright © 2017 Pierluigi D'Andrea. All rights reserved.
//

import Foundation

extension DHController {

    public struct Context {

        let keyId: String

        private let kMaster: Data

        var kSess: Data? {
            return KeyDerivation.kSess(withSequence: 2, kMaster: kMaster)
        }

        var kAuth: Data? {
            return KeyDerivation.kAuth(withSequence: 2, kMaster: kMaster)
        }

        init(keyId: String, kMaster: Data) {

            self.keyId = keyId
            self.kMaster = kMaster

        }

        func saveKeys(with kSafe: Data) throws {

            try Keychain.insert(entry: SatispayInStoreConfig.environment.keychain.kSafe, data: kSafe)
            try Keychain.insert(entry: SatispayInStoreConfig.environment.keychain.kMaster, data: kMaster)
            try Keychain.insert(entry: SatispayInStoreConfig.environment.keychain.keyId, value: keyId)
            try Keychain.insert(entry: SatispayInStoreConfig.environment.keychain.sequenceNumber, value: 2)

        }

    }

}
