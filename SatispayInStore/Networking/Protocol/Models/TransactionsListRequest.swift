//
//  TransactionsListRequest.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

public struct TransactionsListRequest: Encodable {

    let filter: String?
    let offset: String?
    let limit: UInt?

    enum CodingKeys: String, CodingKey {

        case filter
        case offset = "starting_after"
        case limit

    }

    public init(filter: String?, offset: String?, limit: UInt?) {

        self.filter = filter
        self.offset = offset
        self.limit = limit

    }

}

extension TransactionsListRequest {

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

extension TransactionsListRequest.Analytics {

    public enum DeviceType: String {

        case tablet = "TABLET"
        case smartphone = "SMARTPHONE"
        case cashRegister = "CASH-REGISTER"

    }

}
