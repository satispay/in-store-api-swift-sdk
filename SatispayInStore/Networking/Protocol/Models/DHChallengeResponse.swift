//
//  DHChallengeResponse.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

public struct DHChallengeResponse: Decodable {

    public let challenge: String
    public let nonce: String

    enum CodingKeys: String, CodingKey {

        case challenge = "challenge_response"
        case nonce

    }

}
