//
//  PaymentsListRequest.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

public struct PaymentsListRequest: Encodable {

    let status: [Payment.Status]?
    let startingAfter: String?
    let limit: UInt?

    enum CodingKeys: String, CodingKey {

        case status
        case startingAfter = "starting_after"
        case limit

    }

    public init(status: [Payment.Status]?, startingAfter: String?, limit: UInt?) {

        self.status = status
        self.startingAfter = startingAfter
        self.limit = limit

    }

}

extension PaymentsListRequest {

    public struct Analytics {

        let softwareHouse: String
        let softwareName: String
        let softwareVersion: String
        let deviceInfo: String
        let deviceType: DeviceType
        let trackingCode: String?

        public init(softwareHouse: String,
                    softwareName: String,
                    softwareVersion: String,
                    deviceInfo: String,
                    deviceType: DeviceType = .cashRegister,
                    trackingCode: String? = nil) {

            self.softwareHouse = softwareHouse
            self.softwareName = softwareName
            self.softwareVersion = softwareVersion
            self.deviceInfo = deviceInfo
            self.deviceType = deviceType
            self.trackingCode = trackingCode

        }

    }

}

extension PaymentsListRequest.Analytics {

    public enum DeviceType: String {

        case tablet = "TABLET"
        case smartphone = "SMARTPHONE"
        case pc = "PC"
        case cashRegister = "CASH-REGISTER"

    }

}
