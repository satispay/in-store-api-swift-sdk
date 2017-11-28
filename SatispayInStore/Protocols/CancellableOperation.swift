//
//  CancellableOperation.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/11/17.
//  Copyright © 2017 Pierluigi D'Andrea. All rights reserved.
//

import Foundation

/// An asynchronous operation that can be cancelled.
public protocol CancellableOperation {

    /// Cancels the operation.
    func cancel()

}
