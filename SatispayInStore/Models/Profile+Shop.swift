//
//  Profile+Shop.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

extension Profile {

    public struct Shop: Decodable {

        public let type: Kind?
        public let id: String
        public let name: String?
        public let pictureURL: URL?
        public let address: Address?
        public let qrCodeIdentifier: String?

        enum CodingKeys: String, CodingKey {

            case type
            case id
            case name
            case address = "spot_address_bean"
            case pictureURL = "image_url"
            case qrCodeIdentifier = "qr_code_identifier"

        }

        public init(from decoder: Decoder) throws {

            let container = try decoder.container(keyedBy: CodingKeys.self)

            type = try? container.decode(Kind.self, forKey: .type)
            id = try container.decode(String.self, forKey: .id)
            name = try? container.decode(String.self, forKey: .name)
            pictureURL = try? container.decode(URL.self, forKey: .pictureURL)
            address = try? container.decode(Address.self, forKey: .address)
            qrCodeIdentifier = try? container.decode(String.self, forKey: .qrCodeIdentifier)

        }

    }

}

extension Profile.Shop {

    public struct Address: Decodable {

        public let address: String
        public let streetNumber: String?
        public let city: String
        public let zipCode: String?

        enum CodingKeys: String, CodingKey {

            case address
            case city
            case streetNumber = "st_number"
            case zipCode = "zipcode"

        }

        public init(from decoder: Decoder) throws {

            let container = try decoder.container(keyedBy: CodingKeys.self)

            address = try container.decode(String.self, forKey: .address)
            city = try container.decode(String.self, forKey: .city)
            streetNumber = try? container.decode(String.self, forKey: .streetNumber)
            zipCode = try? container.decode(String.self, forKey: .zipCode)

        }

    }

    public enum Kind: String, Codable {

        /// The store can change location at any time.
        case onTheMove = "ON_THE_MOVE"

        /// The store as a fixed geographic location.
        case stable = "STABLE"

    }

}
