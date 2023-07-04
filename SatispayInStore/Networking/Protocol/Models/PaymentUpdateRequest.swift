//
//  PaymentUpdateRequest.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 13/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

public struct PaymentUpdateRequest: Encodable {
    
    enum CodingKeys: String, CodingKey {
        case action
        case paymentMethods = "payment_methods_options"
    }

    let action: PaymentUpdateAction
    let paymentMethods: PaymentMethods?

    public init(action: PaymentUpdateAction, paymentMethods: PaymentMethods? = nil) {
        self.action = action
        self.paymentMethods = paymentMethods
    }
    
    public func encode(to encoder: Encoder) throws {
        var encoder = encoder.container(keyedBy: CodingKeys.self)
        try encoder.encode(action, forKey: .action)
        try encoder.encodeIfPresent(paymentMethods, forKey: .paymentMethods)
    }

}
