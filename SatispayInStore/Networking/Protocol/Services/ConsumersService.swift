//
//  ConsumersService.swift
//  SatispayInStore-iOS
//
//  Created by Andrea Altea on 26/03/2020.
//  Copyright © 2020 Pierluigi D'Andrea. All rights reserved.
//

import Foundation

public enum ConsumersService {
    
    case consumer(phoneNumber: String)
}

extension ConsumersService: NetworkService {
    
    public var baseURL: URL {
        return URL(string: "https://\(SatispayInStoreConfig.environment.remoteHost)/g_business/v1/consumers")!
    }
    
    public var path: String? {
        switch self {
        case .consumer(let phoneNumber):
            return "\(phoneNumber)"
        }
    }
    
    public var queryParameters: [String : Any]? {
        switch self {
        case .consumer:
            return nil
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .consumer:
            return .get
        }
    }
    
    public var body: Data? {
        switch self {
        case .consumer:
            return nil
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .consumer:
            return nil
        }
    }
    
    public var requiresSignature: Bool { true }
    
    public var requiresVerification: Bool { true }
}
