//
//  Payment.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

public struct Payment: Decodable, Equatable {

    public let id: String
    public let status: Status
    public let type: String?
    public let amountUnit: Int
    public let currency: String
    public let insertDate: Date
    public let expired: Bool
    public let expireDate: Date?
    public let dailyClosure: DailyClosure?
    public let sender: Sender?
    public let receiver: Receiver
    public let statusOwnership: Bool?
    public let statusOwner: StatusOwner?
    public let codeIdentifier: String?
    public let paymentDescription: String?
    public let flow: Flow?

    enum CodingKeys: String, CodingKey {

        case id
        case type
        case amountUnit = "amount_unit"
        case currency
        case status
        case insertDate = "insert_date"
        case expired
        case expireDate = "expire_date"
        case dailyClosure = "daily_closure"
        case sender
        case receiver
        case statusOwnership = "status_ownership"
        case statusOwner = "status_owner"
        case codeIdentifier = "code_identifier"
        case paymentDescription = "description"
        case flow
    }

    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        type = try? container.decode(String.self, forKey: .type)
        status = try container.decode(Status.self, forKey: .status)
        amountUnit = try container.decode(Int.self, forKey: .amountUnit)
        currency = try container.decode(String.self, forKey: .currency)
        insertDate = try container.decode(Date.self, forKey: .insertDate)
        expired = try container.decode(Bool.self, forKey: .expired)
        expireDate = try? container.decode(Date.self, forKey: .expireDate)
        dailyClosure = try? container.decode(DailyClosure.self, forKey: .dailyClosure)
        sender = try? container.decode(Sender.self, forKey: .sender)
        receiver = try container.decode(Receiver.self, forKey: .receiver)
        statusOwnership = try? container.decode(Bool.self, forKey: .statusOwnership)
        statusOwner = try? container.decode(StatusOwner.self, forKey: .statusOwner)
        codeIdentifier = try? container.decode(String.self, forKey: .codeIdentifier)
        paymentDescription = try? container.decode(String.self, forKey: .paymentDescription)
        flow = try? container.decode(Payment.Flow.self, forKey: .flow)
    }

}

extension Payment {

    public enum Status: String, Codable {

        /// The transaction can still be either accepted or cancelled. This usually means that the payer is waiting.
        case pending = "PENDING"
        /// The transaction has been accepted.
        case accepted = "ACCEPTED"
        /// The transaction has been cancelled.
        case canceled = "CANCELED"

    }

    public struct DailyClosure: Decodable, Equatable {

        public let id: String
        public let date: Date

    }

    public struct Sender: Decodable, Equatable {

        public let id: String
        public let type: String
        public let name: String?
        public let profilePictures: PaginatedDataResponse<Picture>?

        enum CodingKeys: String, CodingKey {

            case id
            case type
            case name
            case profilePictures = "profile_pictures"

        }

        public init(from decoder: Decoder) throws {

            let container = try decoder.container(keyedBy: CodingKeys.self)

            id = try container.decode(String.self, forKey: .id)
            type = try container.decode(String.self, forKey: .type)
            name = try? container.decode(String.self, forKey: .name)
            profilePictures = try? container.decode(PaginatedDataResponse<Picture>.self, forKey: .profilePictures)

        }

    }

    public struct Receiver: Decodable, Equatable {

        public let id: String
        public let type: String

    }

    public struct StatusOwner: Decodable, Equatable {

        public let id: String
        public let type: String

    }

    public enum Flow: String, Codable, Equatable {
        case charge = "CHARGE"
    }
}
