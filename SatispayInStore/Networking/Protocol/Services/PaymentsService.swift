//
//  PaymentsService.swift
//  SatispayInStore-iOS
//
//  Created by Pierluigi D'Andrea on 15/01/2019.
//  Copyright © 2019 Pierluigi D'Andrea. All rights reserved.
//

import Foundation
#if os(iOS)
import UIKit
#endif

public enum PaymentsService {

    case payments(request: PaymentsListRequest, analytics: PaymentsListRequest.Analytics)
    case createPayment(request: PaymentCreationRequest)
    case updatePayment(id: String, request: PaymentUpdateRequest)

}

extension PaymentsService: NetworkService {

    public var baseURL: URL {
        return URL(string: "https://\(SatispayInStoreConfig.environment.remoteHost)/g_business/v1/payments")!
    }

    public var path: String? {
        switch self {
        case .payments:
            return nil
        case .createPayment:
            return nil
        case .updatePayment(let id, _):
            return "/\(id)"
        }
    }

    public var queryParameters: [String: Any]? {
        switch self {
        case .payments(let request, _):
            guard let data = try? JSONEncoder.encode(request) else {
                return nil
            }

            return (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any]
        case .createPayment:
            return nil
        case .updatePayment:
            return nil
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .payments:
            return .get
        case .createPayment:
            return .post
        case .updatePayment:
            return .put
        }
    }

    public var body: Data? {
        switch self {
        case .payments:
            return nil
        case .createPayment(let request):
            return try? JSONEncoder.encode(request)
        case .updatePayment(_, let request):
            return try? JSONEncoder.encode(request)
        }
    }

    public var headers: [String: String]? {

        guard case .payments(_, let analytics) = self else {
            return nil
        }

        var headers: [String: String] = [
            "x-satispay-deviceinfo": analytics.deviceInfo,
            "x-satispay-apph": analytics.softwareHouse,
            "x-satispay-appn": analytics.softwareName,
            "x-satispay-appv": analytics.softwareVersion,
            "x-satispay-devicetype": analytics.deviceType.rawValue
        ]

        #if os(iOS)
        headers["x-satispay-os"] = UIDevice.current.systemName
        headers["x-satispay-osv"] = UIDevice.current.systemVersion
        #elseif os(macOS)
        headers["x-satispay-os"] = "macOS"
        headers["x-satispay-osv"] = ProcessInfo.processInfo.operatingSystemVersionString
        #endif

        headers["x-satispay-tracking-code"] = analytics.trackingCode

        return headers

    }

    public var requiresSignature: Bool {
        return true
    }

    public var requiresVerification: Bool {
        return true
    }

}
