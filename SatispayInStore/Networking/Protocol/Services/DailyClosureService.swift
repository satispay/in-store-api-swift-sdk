//
//  DailyClosureService.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 31/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

public enum DailyClosureService {

    case closure(day: String, type: DailyClosureResponse.Kind)

}

extension DailyClosureService: NetworkService {

    public var baseURL: URL {
        return URL(string: "https://\(SatispayInStoreConfig.environment.remoteHost)/spot/v2/daily_closure/")!
    }

    public var path: String? {
        switch self {
        case .closure(let day, let type):
            return "\(day)/type/\(type.rawValue)"
        }
    }

    public var queryParameters: [String: Any]? {
        return nil
    }

    public var method: HTTPMethod {
        switch self {
        case .closure:
            return .get
        }
    }

    public var body: Data? {
        return nil
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
