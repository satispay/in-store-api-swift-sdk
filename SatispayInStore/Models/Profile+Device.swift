//
//  Profile+Device.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

extension Profile {

    public struct Device: Decodable {

        /// Device status.
        /// - note: Disabled devices should kick the user out.
        public let isEnabled: Bool

        /// Whether the server needs the location of the device.
        public let mustGeolocate: Bool

        enum CodingKeys: String, CodingKey {

            case isEnabled = "enable"
            case mustGeolocate = "must_geolocate"

        }

        public init(from decoder: Decoder) throws {

            let container = try decoder.container(keyedBy: CodingKeys.self)

            isEnabled = (try? container.decode(Bool.self, forKey: .isEnabled)) ?? false
            mustGeolocate = (try? container.decode(Bool.self, forKey: .mustGeolocate)) ?? false

        }

    }

}
