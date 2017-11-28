//
//  TransactionsService.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation
import UIKit

public enum TransactionsService {

    case list(request: TransactionsListRequest, analytics: TransactionsListRequest.Analytics)

    case updateState(id: String, request: TransactionStateUpdateRequest)

    case refund(id: String)

}

extension TransactionsService: NetworkService {

    public var baseURL: URL {
        return URL(string: "https://\(SatispayInStoreConfig.environment.remoteHost)/spot/")!
    }

    public var path: String? {
        switch self {
        case .list:
            return "v2.1/transactions"
        case .updateState(let id, _):
            return "v2.1/transactions/\(id)/state"
        case .refund(let id):
            return "v2.1/transactions/\(id)/refunds"
        }
    }

    public var queryParameters: [String: Any]? {
        switch self {
        case .list(let request, _):
            guard let data = try? JSONEncoder.encode(request) else {
                return nil
            }

            return (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any]
        case .updateState,
             .refund:
            return nil
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .list:
            return .get
        case .updateState:
            return .put
        case .refund:
            return .post
        }
    }

    public var body: Data? {
        switch self {
        case .list:
            return nil
        case .updateState(_, let request):
            return try? JSONEncoder.encode(request)
        case .refund:
            return nil
        }
    }

    public var headers: [String: String]? {

        guard case .list(_, let analytics) = self else {
            return nil
        }

        var headers: [String: String] = [
            "x-satispay-deviceinfo": analytics.deviceInfo,
            "x-satispay-os": UIDevice.current.systemName,
            "x-satispay-osv": UIDevice.current.systemVersion,
            "x-satispay-apph": analytics.softwareHouse,
            "x-satispay-appn": analytics.softwareName,
            "x-satispay-appv": analytics.softwareVersion,
            "x-satispay-devicetype": analytics.deviceType.rawValue
        ]

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
