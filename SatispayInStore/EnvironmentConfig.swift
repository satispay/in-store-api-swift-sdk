//
//  EnvironmentConfig.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 08/11/17.
//  Copyright © 2017 Pierluigi D'Andrea. All rights reserved.
//

import Foundation

/// Server environment.
public protocol EnvironmentConfig {

    /// Host to send the requests to.
    var remoteHost: String { get }

    /// Public key to use to encrypt the DH challenge payload.
    var publicKey: String { get }

    /// Keychain items config.
    var keychain: EnvironmentKeychainConfig { get }

    /// URLSession instance to use to perform HTTP requests.
    var urlSession: URLSession { get }

}
