//
//  DHExchangeResponse.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

public struct DHExchangeResponse: Decodable {

    public let keyId: String
    public let publicKey: String

    enum CodingKeys: String, CodingKey {
        case keyId = "user_key_id"
        case publicKey = "public_key"
    }

}
