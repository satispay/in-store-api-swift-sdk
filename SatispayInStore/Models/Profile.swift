//
//  Profile.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

public struct Profile: Decodable {

    public let id: String
    public let merchantUid: String
    public let name: String?
    public let address: Address?
    public let geolocation: Geolocation?
    public let images: [Picture]?
    public let localization: Localization?
    public let acceptance: Acceptance?
    public let costCentre: String?
    public let qrCodeIdentifier: String?
    public let rawModel: String?

    public var model: Model {
        if let rawModel = rawModel, let identifier = Model.Identifier(rawValue: rawModel) {
            return .identifier(identifier)
        }

        return .unknown(rawModel)
    }

    enum CodingKeys: String, CodingKey {

        case id
        case merchantUid = "merchant_uid"
        case name
        case address
        case geolocation
        case images
        case localization
        case acceptance
        case costCentre = "cost_centre"
        case qrCodeIdentifier = "qr_code_identifier"
        case rawModel = "model"

    }

    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        merchantUid = try container.decode(String.self, forKey: .merchantUid)
        name = try? container.decode(String.self, forKey: .name)
        address = try? container.decode(Address.self, forKey: .address)
        geolocation = try? container.decode(Geolocation.self, forKey: .geolocation)
        images = try? container.decode([Picture].self, forKey: .images)
        localization = try? container.decode(Localization.self, forKey: .localization)
        acceptance = try? container.decode(Acceptance.self, forKey: .acceptance)
        costCentre = try? container.decode(String.self, forKey: .costCentre)
        qrCodeIdentifier = try? container.decode(String.self, forKey: .qrCodeIdentifier)
        rawModel = try container.decode(String.self, forKey: .rawModel)

    }

}

public extension Profile {

    struct Address: Decodable {

        public let address: String
        public let streetNumber: String?
        public let city: String
        public let zipCode: String?
        public let country: String?

        enum CodingKeys: String, CodingKey {

            case address
            case city
            case streetNumber = "st_number"
            case zipCode = "zip_code"
            case country

        }

        public init(from decoder: Decoder) throws {

            let container = try decoder.container(keyedBy: CodingKeys.self)

            address = try container.decode(String.self, forKey: .address)
            city = try container.decode(String.self, forKey: .city)
            streetNumber = try? container.decode(String.self, forKey: .streetNumber)
            zipCode = try? container.decode(String.self, forKey: .zipCode)
            country = try? container.decode(String.self, forKey: .country)

        }

    }

    struct Geolocation: Decodable {

        public let latitude: Double
        public let longitude: Double

        enum CodingKeys: String, CodingKey {
            case latitude = "lat"
            case longitude = "lon"
        }

    }

    enum Localization: String, Decodable {
        case `static` = "STATIC"
        case onTheMove = "ON_THE_MOVE"
        case hidden = "HIDDEN"
    }

    enum Acceptance: String, Decodable {
        case acceptance = "ACCEPTANCE"
        case fundLock = "FUND_LOCK"
        case implicit = "IMPLICIT"
        case none = "NONE"
    }

    enum Model {
        case identifier(Identifier)
        case unknown(String?)

        public enum Identifier: String {
            case brickAndMortar = "BRICK_AND_MORTAR"
            case onTheMove = "ON_THE_MOVE"
            case ecommerceWebsite = "ECOMMERCE_WEBSITE"
            case ecommerceMobileApp = "ECOMMERCE_MOBILE_APP"
            case socialMediaPlatform = "SOCIAL_MEDIA_PLATFORM"
            case smartVendingMachine = "SMART_VENDING_MACHINE"
            case vendingMachine = "VENDING_MACHINE"
        }
    }

}
