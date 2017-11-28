//
//  NetworkController.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 10/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

open class NetworkController {

    /// SatispayInStore protocol requests completion handler.
    public typealias CompletionHandler<Response> = (Response?, NetworkServiceError?) -> Void

    public init() {
    }

}

extension NetworkController {

    static func attemptDecode<T: Decodable>(of data: Data) throws -> T {

        do {

            return try JSONDecoder.decode(T.self, from: data)

        } catch let mappingError {

            let error: ServerErrorResponse

            do {
                error = try JSONDecoder.decode(ServerErrorResponse.self, from: data)
            } catch {
                throw mappingError
            }

            throw error

        }

    }

}
