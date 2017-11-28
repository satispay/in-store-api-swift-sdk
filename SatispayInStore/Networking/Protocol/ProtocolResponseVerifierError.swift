//
//  ResponseVerifierError.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 07/11/17.
//  Copyright © 2017 Pierluigi D'Andrea. All rights reserved.
//

import Foundation

public enum ProtocolResponseVerifierError: Error {

    /// The status code of the response is not in the [200, 399] range.
    case statusCode

    /// `ProtocolResponseVerifier` failed to read either `kMaster` or `sequence number` from the keychain.
    case missingKeychainEntries

    /// The response doesn't contain a formally valid authentication header.
    case malformedResponse

    /// The digest in the response headers is not correct.
    case digestMismatch

    /// The signature in the response headers is not correct.
    case invalidSignature

}
