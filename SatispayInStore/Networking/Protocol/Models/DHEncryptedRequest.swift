//
//  DHEncryptedRequest.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

public struct DHEncryptedRequest: Encodable {

    let keyId: String
    let sequenceNumber = 2
    let performance = "LOW"

    let payload: Data
    let hmac: Data

    enum CodingKeys: String, CodingKey {

        case keyId = "user_key_id"
        case sequenceNumber = "sequence_number"
        case performance = "performance_device"
        case payload = "encrypted_payload"
        case hmac

    }

    public init<Content: Encodable>(keyId: String, kAuth: Data, kSess: Data, payload: Content) throws {

        let data = try JSONEncoder.encode(payload)

        self.payload = try AES.encrypt(data: data, usingKey: kSess)
        self.keyId = keyId
        self.hmac = HMAC.sha256(of: data, usingKey: kAuth).digest

    }

}
