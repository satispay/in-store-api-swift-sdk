//
//  Profile.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

/// Session profile.
public struct Profile: Decodable {

    /// Shop info (name, picture, address and so on).
    public let shop: Shop

    /// Device info (status, capabilities).
    public let device: Device

    enum CodingKeys: String, CodingKey {

        case shop = "spot_shop_bean"
        case device = "spot_device_bean"

    }

    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        shop = try container.decode(Shop.self, forKey: .shop)
        device = try container.decode(Device.self, forKey: .device)

    }

}
