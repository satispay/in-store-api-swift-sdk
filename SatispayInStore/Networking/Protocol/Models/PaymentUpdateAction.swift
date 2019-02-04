//
//  PaymentUpdateAction.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 15/01/2019.
//  Copyright © 2019 Pierluigi D'Andrea. All rights reserved.
//

import Foundation

public enum PaymentUpdateAction: String, Codable {
    case accept = "ACCEPT"
    case cancel = "CANCEL"
}
