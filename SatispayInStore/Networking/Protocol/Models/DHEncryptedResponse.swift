//
//  DHEncryptedRequest.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

public struct DHEncryptedResponse: Decodable {

    let payload: Data
    let hmac: Data

    enum CodingKeys: String, CodingKey {

        case payload = "encrypted_payload"
        case hmac

    }

    public func decrypt(kSess: Data, kAuth: Data) throws -> Data {

        guard let decryptedData = try? AES.decrypt(data: payload, usingKey: kSess) else {
            throw DHError.verificationResponseDecryptionFailure
        }

        guard hmac == HMAC.sha256(of: decryptedData, usingKey: kAuth).digest else {
            throw DHError.verificationResponseDecryptionFailure
        }

        return decryptedData

    }

}
