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
    let deviceInfo: String
    let appVersion: String

    #if os(macOS)
    private let os = "macOS"
    private let osVersion: String = ProcessInfo.processInfo.operatingSystemVersionString
    #else
    private let os: String = UIDevice.current.systemName
    private let osVersion: String = UIDevice.current.systemVersion
    #endif

    enum CodingKeys: String, CodingKey {

        case udid
        case language
        case deviceInfo = "device_model"
        case os = "os_app"
        case osVersion = "os_version"
        case appVersion = "app_version"

    }

    public init(udid: String?, language: String, deviceInfo: String, appVersion: String) {

        self.language = language
        self.udid = udid
        self.deviceInfo = deviceInfo
        self.appVersion = appVersion

    }

}
