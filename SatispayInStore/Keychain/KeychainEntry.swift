//
//  KeychainEntry.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 17/10/16.
//  Copyright © 2016 Satispay. All rights reserved.
//

import Foundation

public protocol KeychainEntry {

    var valueClass: String { get }
    var descriptor: [String: Any] { get }

}
