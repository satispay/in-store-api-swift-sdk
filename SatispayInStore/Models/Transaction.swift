//
//  Transaction.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

/// Payment transaction.
public struct Transaction: Decodable, Equatable {

    /// Unique id.
    public let id: String

    /// Transaction state.
    public let state: TransactionState

    /// Transaction type.
    public let type: TransactionType?

    /// Transaction amount in cents.
    public let amount: Int

    /// Date when the transaction was last updated.
    public let date: Date?

    /// Unique identifier of the shop that received the payment.
    public let shopId: String?
    /// Unique identifier of the device that received the payment.
    public let deviceUid: String?
    /// Type of the device that received the payment.
    public let deviceType: String?

    /// Payer's name.
    public let consumerName: String?
    /// Payer's profile picture url.
    public let consumerImageURL: URL?
    /// Payer's unique identifier.
    public let consumerId: String?

    /// Identifier the day the transaction falls in.
    public let dailyClosure: String?
    /// Date of the day the transaction falls in.
    public let dailyClosureDate: Date?

    enum CodingKeys: String, CodingKey {

        case id = "transaction_id"
        case type
        case amount
        case date = "transaction_date"
        case state
        case consumer
        case dailyClosure = "daily_closure"
        case dailyClosureDate = "daily_closure_date"
        case deviceUid = "device_uid"
        case deviceType = "device_type"

    }

    enum ConsumerCodingKeys: String, CodingKey {

        case name
        case imageURL = "image_url"
        case id

    }

    enum ShopCodingKeys: String, CodingKey {

        case id

    }

    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        type = try? container.decode(TransactionType.self, forKey: .type)
        state = try container.decode(TransactionState.self, forKey: .state)
        amount = try container.decode(Int.self, forKey: .amount)
        date = try? container.decode(Date.self, forKey: .date)
        dailyClosure = try? container.decode(String.self, forKey: .dailyClosure)
        dailyClosureDate = try? container.decode(Date.self, forKey: .dailyClosureDate)
        deviceUid = try? container.decode(String.self, forKey: .deviceUid)
        deviceType = try? container.decode(String.self, forKey: .deviceType)

        let shopContainer = try container.nestedContainer(keyedBy: ShopCodingKeys.self, forKey: .consumer)

        shopId = try? shopContainer.decode(String.self, forKey: .id)

        let consumerContainer = try container.nestedContainer(keyedBy: ConsumerCodingKeys.self, forKey: .consumer)

        consumerId = try? consumerContainer.decode(String.self, forKey: .id)
        consumerName = try? consumerContainer.decode(String.self, forKey: .name)
        consumerImageURL = try? consumerContainer.decode(URL.self, forKey: .imageURL)

    }

}

public enum TransactionType: String, Codable {

    /// Refund transaction.
    case refund = "RM2P"
    /// Payment received from a customer.
    case c2b = "C2B"

}

public enum TransactionState: String, Codable {

    /// The transaction can still be either approved or cancelled. This usually means that the payer is waiting.
    case pending = "PENDING"
    /// The transaction has been approved.
    case approved = "APPROVED"
    /// The transaction has been cancelled.
    case cancelled = "CANCELED"

}
