//
//  DHChallengeRequest.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

public struct DHChallengeRequest: Encodable {

    let uuid: String = UUID().uuidString
    let challenge: Data

    enum CodingKeys: String, CodingKey {
        case challenge
    }

    public init() throws {

        challenge = try RSA.encrypt(string: uuid, using: SatispayInStoreConfig.environment.keychain.publicKey)

    }

}
