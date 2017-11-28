//
//  DailyClosureResponse.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 31/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

public struct DailyClosureResponse: Decodable {

    enum CodingKeys: String, CodingKey {

        case amount = "amount_unit"
        case currency

    }

    public let amount: Int
    public let currency: String

}

extension DailyClosureResponse {

    public enum Kind: String {

        case shop = "SHOP"
        case device = "DEVICE"

    }

}
