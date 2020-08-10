//
//  NetworkService.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

public protocol NetworkService {

    /// Service base path
    var baseURL: URL { get }

    /// Endpoint path
    var path: String? { get }

    /// Query parameters
    var queryParameters: [URLQueryItem]? { get }

    /// Request method
    var method: HTTPMethod { get }

    /// Request body
    var body: Data? { get }

    /// Request HTTP headers
    var headers: [String: String]? { get }

    /// Whether to sign the request
    var requiresSignature: Bool { get }

    /// Whether to verify the response
    var requiresVerification: Bool { get }

}

extension NetworkService {

    private var url: URL {

        let partialURL: URL

        if let path = path {
            partialURL = baseURL.appendingPathComponent(path)
        } else {
            partialURL = baseURL
        }

        guard let params = queryParameters else {
            return partialURL
        }

        var components = URLComponents(url: partialURL, resolvingAgainstBaseURL: false)!
        
        components.queryItems = params

        return components.url!

    }

    var urlRequest: URLRequest {

        var request = URLRequest(url: url)

        request.httpMethod = method.rawValue.uppercased()
        request.httpBody = body

        if let customHeaders = headers {
            for (key, value) in customHeaders {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        guard requiresSignature else {
            return request
        }

        guard let keyId: String = try? Keychain.find(entry: SatispayInStoreConfig.environment.keychain.keyId),
            let kMaster: Data = try? Keychain.find(entry: SatispayInStoreConfig.environment.keychain.kMaster),
            let sequence: Int = try? Keychain.find(entry: SatispayInStoreConfig.environment.keychain.sequenceNumber) else {
            return request
        }

        guard let signed = try? ProtocolRequestSigner(keyId: keyId, kMaster: kMaster, sequenceNumber: sequence).signed(request: request) else {
            return request
        }

        return signed

    }
    
    func queryItemsMap(_ parameters: [String: Any]?) -> [URLQueryItem]? {
        
        return parameters?.flatMap { (key, value) -> [URLQueryItem] in
            guard let values = value as? [String] else {
                return [URLQueryItem(name: key, value: value as? String)]
            }
            return values.map { URLQueryItem(name: key, value: $0) }
        }
        
    }

}
