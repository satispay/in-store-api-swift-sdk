//
//  TransactionRefundResponse.swift
//  SatispayInStore-iOS
//
//  Created by Pierluigi D'Andrea on 24/11/17.
//  Copyright © 2017 Pierluigi D'Andrea. All rights reserved.
//

import Foundation

public struct TransactionRefundResponse: Decodable {

    public let id: String
    public let parentId: String
    public let date: Date?
    public let amount: Int
    public let state: Payment.Status
    public let expired: Bool
    public let comment: String?

    enum CodingKeys: String, CodingKey {

        case id = "transaction_id"
        case parentId = "parent_transaction_id"
        case date = "transaction_date"
        case amount
        case state
        case expired
        case comment

    }

}
