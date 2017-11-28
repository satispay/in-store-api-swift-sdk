//
//  KeychainError.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 03/10/16.
//  Copyright © 2016 Satispay. All rights reserved.
//

import Foundation

/// Keychain errors
public enum KeychainError: Error {

    /// Generic failure
    case failure(OSStatus)
    /// Invalid data inserted/fetched
    case invalidData
    /// Entry not found
    case notFound

}
