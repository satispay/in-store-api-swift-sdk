//
//  AnalyticsService.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import CoreLocation
import Foundation

public enum AnalyticsService {

    case started(request: StartedRequest)

}

extension AnalyticsService: NetworkService {

    public var baseURL: URL {
        return URL(string: "https://\(SatispayInStoreConfig.environment.remoteHost)/spot/v2/analytics/")!
    }

    public var path: String? {
        switch self {
        case .started:
            return "events/started"
        }
    }

    public var queryParameters: [String: Any]? {
        return nil
    }

    public var method: HTTPMethod {
        switch self {
        case .started:
            return .post
        }
    }

    public var body: Data? {
        switch self {
        case .started(let request):
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
