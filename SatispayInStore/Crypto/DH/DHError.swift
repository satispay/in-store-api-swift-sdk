//
//  DHError.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 08/11/17.
//  Copyright © 2017 Pierluigi D'Andrea. All rights reserved.
//

import Foundation

/// DH exchange error.
public enum DHError: Int, Error {

    /// The public key used to configure the environment is malformed.
    case cannotImportPublicKey

    /// An error occurred generating the dh parameters: `(p, g, publicKey)`.
    case cannotGenerateParameters

    /// `(p, g, publicKey)` contains an invalid value.
    case invalidDHParams

    /// The exchange response wasn't valid.
    case exchangeResponseFailure

    /// The challenge request failed encypting the UUID.
    case cannotEncryptUUID
    /// The challenge request failed getting the shared secret from the dh params.
    case cannotComputeSharedSecret

    /// The challenge response wasn't valid.
    case challengeResponseFailure
    /// The UUID in challenge response doesn't match the UUID in the request.
    case challengeResponseVerificationFailure

    /// The verification request failed.
    case verificationFailure
    /// The verification response decryption failed.
    case verificationResponseDecryptionFailure

    /// The provided activation code was not valid.
    case tokenVerificationFailure

}
