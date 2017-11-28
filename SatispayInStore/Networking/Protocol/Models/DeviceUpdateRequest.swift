//
//  DeviceUpdateRequest.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import UIKit

public struct DeviceUpdateRequest: Encodable {

    let environment: String
    let os = "iOS"
    let osVersion: String
    let appVersion: String

    let pushToken: String?

    enum CodingKeys: String, CodingKey {

        case environment
        case os = "os_app"
        case osVersion = "os_version"
        case appVersion = "app_version"

        case pushToken = "token"

    }

    public init(pushToken token: String?) {

        appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0"
        osVersion = UIDevice.current.systemVersion

        #if DEBUG
        environment = "SANDBOX"
        #else
        environment = "PRODUCTION"
        #endif

        pushToken = token

    }

}
