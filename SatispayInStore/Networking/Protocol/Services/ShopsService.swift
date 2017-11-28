//
//  ShopsService.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import CoreLocation
import Foundation

public enum ShopsService {

    case updateLocation(shopId: String, request: ShopLocationUpdateRequest)

}

extension ShopsService: NetworkService {

    public var baseURL: URL {
        return URL(string: "https://\(SatispayInStoreConfig.environment.remoteHost)/spot/v2/shops/")!
    }

    public var path: String? {
        switch self {
        case .updateLocation(let id, _):
            return "\(id)/location"
        }
    }

    public var queryParameters: [String: Any]? {
        return nil
    }

    public var method: HTTPMethod {
        switch self {
        case .updateLocation:
            return .put
        }
    }

    public var body: Data? {
        switch self {
        case .updateLocation(_, let request):
            return try? JSONEncoder.encode(request)
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
