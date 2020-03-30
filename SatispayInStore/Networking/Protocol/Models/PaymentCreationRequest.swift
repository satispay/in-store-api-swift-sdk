//
//  PaymentCreationRequest.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 04/02/2019.
//  Copyright © 2019 Pierluigi D'Andrea. All rights reserved.
//

import Foundation

public struct PaymentCreationRequest: Encodable {

    public let flow: Flow
    public let amountUnit: Int
    public let currency: String
    public let expirationDate: Date?
    public let metadata: Metadata?
    public let callbackURL: URL?
    public let parentPaymentUid: String?
    public let consumerUid: String?
    public let comment: String?

    enum CodingKeys: String, CodingKey {
        case flow
        case amountUnit = "amount_unit"
        case currency
        case expirationDate = "expiration_date"
        case metadata
        case callbackURL = "callback_url"
        case parentPaymentUid = "parent_payment_uid"
        case consumerUid = "consumer_uid"
        case comment
    }

    public init(flow: Flow, amountUnit: Int, currency: String, expirationDate: Date?, metadata: Metadata?, callbackURL: URL?, parentPaymentUid: String?, consumerUid: String?, comment: String?) {
        self.flow = flow
        self.amountUnit = amountUnit
        self.currency = currency
        self.expirationDate = expirationDate
        self.metadata = metadata
        self.callbackURL = callbackURL
        self.parentPaymentUid = parentPaymentUid
        self.consumerUid = consumerUid
        self.comment = comment
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(flow, forKey: .flow)
        try container.encode(amountUnit, forKey: .amountUnit)
        try container.encode(currency, forKey: .currency)
        try container.encodeIfPresent(expirationDate, forKey: .expirationDate)
        try container.encodeIfPresent(metadata, forKey: .metadata)
        try container.encodeIfPresent(callbackURL, forKey: .callbackURL)
        try container.encodeIfPresent(parentPaymentUid, forKey: .parentPaymentUid)
        try container.encodeIfPresent(consumerUid, forKey: .consumerUid)
        try container.encodeIfPresent(comment, forKey: .comment)
    }
}

extension PaymentCreationRequest {

    public enum Flow: String, Encodable {
        case matchUser = "MATCH_USER"
        case matchCode = "MATCH_CODE"
        case refund = "REFUND"
    }

}

extension PaymentCreationRequest {

    public struct Metadata: Encodable {

        let payload: Encodable

        public init(payload: Encodable) {
            self.payload = payload
        }

        public func encode(to encoder: Encoder) throws {
            try payload.encode(to: encoder)
        }

    }

}
