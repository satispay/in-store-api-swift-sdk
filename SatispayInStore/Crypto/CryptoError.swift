//
//  CryptoError.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 08/11/17.
//  Copyright © 2017 Pierluigi D'Andrea. All rights reserved.
//

import Foundation

enum CryptoError: Error {

    case malformedData
    case encryptionFailure(OSStatus)
    case decryptionFailure(OSStatus)

}
