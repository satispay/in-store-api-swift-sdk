//
//  ProtocolRequestSignerError.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 08/11/17.
//  Copyright © 2017 Pierluigi D'Andrea. All rights reserved.
//

import Foundation

enum ProtocolRequestSignerError: Error {

    /// The request was not configured properly.
    case invalidRequest

    /// The request couldn't be signed.
    case signatureFailure

}
