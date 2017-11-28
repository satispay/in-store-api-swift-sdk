//
//  TransactionStateUpdateResponse.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 13/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

public struct TransactionStateUpdateResponse: Decodable {

    public let id: String
    public let date: Date?
    public let amount: Int
    public let state: TransactionState

    enum CodingKeys: String, CodingKey {

        case id = "transaction_id"
        case date = "transaction_date"
        case amount
        case state

    }

}
