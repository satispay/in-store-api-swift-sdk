//
//  ProfileService.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

public enum ProfileService {

    case me(request: ProfileMeRequest)
    case acceptance(request: ProfileAcceptanceRequest)
}

extension ProfileService: NetworkService {

    public var baseURL: URL {
        return URL(string: "https://\(SatispayInStoreConfig.environment.remoteHost)/g_business/v1/profile/")!
    }

    public var path: String? {
        switch self {
        case .me, .acceptance:
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
        case .acceptance:
            return .patch
        }
    }

    public var body: Data? {
        switch self {
        case .me: return nil
        case .acceptance(let request):
            return try? JSONEncoder.encode(request)
        }
    }

    public var headers: [String: String]? {
        switch self {
        case .me(let request):
            var headers = [String: String]()
            
            #if os(iOS)
            headers["x-satispay-os"] = UIDevice.current.systemName
            #elseif os(macOS)
            headers["x-satispay-os"] = "macOS"
            #endif
            
            headers["x-satispay-apph"] = request.softwareHouse
            headers["x-satispay-appn"] = request.softwareName
            return headers
            
        default: return nil
        }
    }

    public var requiresSignature: Bool {
        return true
    }

    public var requiresVerification: Bool {
        return true
    }

}
