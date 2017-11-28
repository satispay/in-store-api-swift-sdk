//
//  ProfileService.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

public enum ProfileService {

    case me

}

extension ProfileService: NetworkService {

    public var baseURL: URL {
        return URL(string: "https://\(SatispayInStoreConfig.environment.remoteHost)/spot/v2/profile/")!
    }

    public var path: String? {
        switch self {
        case .me:
            return "me"
        }
    }

    public var queryParameters: [String: Any]? {
        return nil
    }

    public var method: HTTPMethod {
        switch self {
        case .me:
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
