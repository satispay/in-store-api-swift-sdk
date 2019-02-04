//
//  TransactionsService.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation
#if os(iOS)
import UIKit
#endif

public enum TransactionsService {
    case refund(id: String)
}

extension TransactionsService: NetworkService {

    public var baseURL: URL {
        return URL(string: "https://\(SatispayInStoreConfig.environment.remoteHost)/spot/")!
    }

    public var path: String? {
        switch self {
        case .refund(let id):
            return "v2.1/transactions/\(id)/refunds"
        }
    }

    public var queryParameters: [String: Any]? {
        return nil
    }

    public var method: HTTPMethod {
        switch self {
        case .refund:
            return .post
        }
    }

    public var body: Data? {
        switch self {
        case .refund:
            return nil
        }
    }

    public var headers: [String: String]? {
        return nil
    }

    public var requiresSignature: Bool {
        return true
    }

    public var requiresVerification: Bool {
        return true
    }

}
