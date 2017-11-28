//
//  SpotProtocol.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 12/02/16.
//  Copyright © 2016 Satispay. All rights reserved.
//

import Foundation

/// Generic Protocol related errors
enum ProtocolError: Int, Error {

    /// Unspecified error
    case unknown
    /// The input passed to a RACCommand or function is not valid
    case invalidInput
    /// The response is not valid
    case invalidResponse
    /// The response is missing mandatory header fields
    case missingHeaders
    /// The response contains a digest in an unknown hashing algorithm
    case unknownDigest
    /// The response contains a digest that doesn't match
    case digestMismatch
    /// The response is missing the signature
    case missingSignature
    /// The response has an invalid signature
    case invalidSignature

}
