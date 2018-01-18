//
//  StartedRequest.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import CoreLocation
import Foundation

public struct StartedRequest: Encodable {

    let udid: String?
    let language: String

    enum CodingKeys: String, CodingKey {

        case udid
        case language

    }

    public init(udid: String?, language: String) {

        self.language = language
        self.udid = udid

    }

}
