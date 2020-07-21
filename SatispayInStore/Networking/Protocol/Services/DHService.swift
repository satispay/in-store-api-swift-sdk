//
//  DHService.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

public enum DHService {

    case exchange(request: DHExchangeRequest)
    case challenge(request: DHEncryptedRequest)
    case verify(request: DHEncryptedRequest)

}

extension DHService: NetworkService {

    public var baseURL: URL {
        return URL(string: "https://\(SatispayInStoreConfig.environment.remoteHost)/spot/v2/dh/")!
    }

    public var path: String? {
        switch self {
        case .exchange:
            return "exchange"
        case .challenge:
            return "challenge"
        case .verify:
            return "verify"
        }
    }

    public var queryParameters: [URLQueryItem]? {
        return nil
    }

    public var method: HTTPMethod {
        switch self {
        case .exchange, .challenge, .verify:
            return .post
        }
    }

    public var body: Data? {
        switch self {
        case .exchange(let request):
            return try? JSONEncoder.encode(request)
        case .challenge(let request):
            return try? JSONEncoder.encode(request)
        case .verify(let request):
            return try? JSONEncoder.encode(request)
        }
    }

    public var headers: [String: String]? {
        return nil
    }

    public var requiresSignature: Bool {
        return false
    }

    public var requiresVerification: Bool {
        return false
    }

}
