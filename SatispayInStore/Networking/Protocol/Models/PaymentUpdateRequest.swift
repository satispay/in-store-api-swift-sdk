//
//  PaymentUpdateRequest.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 13/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

public struct PaymentUpdateRequest: Encodable {

    let action: PaymentUpdateAction

    public init(action: PaymentUpdateAction) {
        self.action = action
    }

}
