//
//  DevicesService.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

public enum DevicesService {

    case updateDevice(request: DeviceUpdateRequest)

}

extension DevicesService: NetworkService {

    public var baseURL: URL {
        return URL(string: "https://\(SatispayInStoreConfig.environment.remoteHost)/spot/v2/devices")!
    }

    public var path: String? {
        return nil
    }

    public var queryParameters: [String: Any]? {
        return nil
    }

    public var method: HTTPMethod {
        switch self {
        case .updateDevice:
            return .post
        }
    }

    public var body: Data? {
        switch self {
        case .updateDevice(let request):
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
