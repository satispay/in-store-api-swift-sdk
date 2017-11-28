//
//  DHVerificationRequest.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

public struct DHVerificationRequest: Encodable {

    let nonce: Data
    let kSafe: Data
    let token: String

    enum CodingKeys: String, CodingKey {

        case nonce = "nonce_inc"
        case kSafe = "ksafe_server"
        case token

    }

    init(nonce: Data, kSafe: Data, token: String) {

        self.nonce = nonce
        self.kSafe = kSafe
        self.token = token

    }

}
