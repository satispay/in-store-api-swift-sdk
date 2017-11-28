//
//  NetworkService+Request.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 08/11/17.
//  Copyright © 2017 Pierluigi D'Andrea. All rights reserved.
//

import Foundation

extension NetworkService {

    public typealias CompletionHandler<Response: Decodable> = (Response?, URLResponse?, NetworkServiceError?) -> Void

    public func request<Response: Decodable>(completionHandler: @escaping CompletionHandler<Response>) -> HTTPRequest {

        return request(mapping: { try JSONDecoder.decode(Response.self, from: $0) },
                       completionHandler: completionHandler)

    }

    public func request<Response: Decodable>(mapping: @escaping ((Data) throws -> Response),
                                             completionHandler: @escaping CompletionHandler<Response>) -> HTTPRequest {

        let urlRequest = self.urlRequest
        let request = HTTPRequest(urlRequest: urlRequest)

        let wrappedCompletionHandler: CompletionHandler<Response> = { (response, urlResponse, error) in

            var userInfo = [AnyHashable: Any]()

            userInfo[NetworkServiceNotificationKey.request] = urlRequest
            userInfo[NetworkServiceNotificationKey.error] = error

            NotificationCenter.default.post(.init(name: Notification.Name.NetworkService.didComplete,
                                                  object: nil,
                                                  userInfo: userInfo))

            DispatchQueue.main.async {
                completionHandler(response, urlResponse, error)
            }

        }

        request.resume { (data, response, error) in

            guard let data = data, let response = response else {
                return wrappedCompletionHandler(nil, nil, .any(error))
            }

            do {

                try self.verify(data: data, response: response)
                wrappedCompletionHandler(try mapping(data), response, nil)

            } catch let error {

                if let errorResponse = try? JSONDecoder().decode(ServerErrorResponse.self, from: data) {
                    wrappedCompletionHandler(nil, response, .response(errorResponse))
                } else {
                    wrappedCompletionHandler(nil, response, .any(error))
                }

            }

        }

        NotificationCenter.default.post(.init(name: Notification.Name.NetworkService.didResume,
                                              object: nil,
                                              userInfo: [NetworkServiceNotificationKey.request: urlRequest]))

        request.cancellation = {

            NotificationCenter.default.post(.init(name: Notification.Name.NetworkService.didCancel,
                                                  object: nil,
                                                  userInfo: [NetworkServiceNotificationKey.request: urlRequest]))

        }

        return request

    }

    private func verify(data: Data, response: URLResponse) throws {

        if let httpResponse = response as? HTTPURLResponse, !(200...399).contains(httpResponse.statusCode) {
            throw ProtocolResponseVerifierError.statusCode
        }

        guard requiresVerification else {
            return
        }

        guard let kMaster: Data = try? Keychain.find(entry: SatispayInStoreConfig.environment.keychain.kMaster),
            let sequence: Int = try? Keychain.find(entry: SatispayInStoreConfig.environment.keychain.sequenceNumber) else {
            throw ProtocolResponseVerifierError.missingKeychainEntries
        }

        try ProtocolResponseVerifier(kMaster: kMaster, sequenceNumber: sequence).verify(data: data, response: response)

    }

}
