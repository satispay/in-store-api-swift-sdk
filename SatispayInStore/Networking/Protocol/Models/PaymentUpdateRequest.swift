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

public extension PaymentUpdateRequest {
    
    struct PaymentMethods: Encodable {
        
        enum CodingKeys: String, CodingKey {
            case mealVoucher = "meal_voucher"
        }
        
        let mealVoucher: MealVoucher?
        
        public init(mealVoucher: MealVoucher? = nil) {
            self.mealVoucher = mealVoucher
        }
        
        public func encode(to encoder: Encoder) throws {
            var encoder = encoder.container(keyedBy: CodingKeys.self)
            try encoder.encodeIfPresent(mealVoucher, forKey: .mealVoucher)
        }
        
    }
    
}

public extension PaymentUpdateRequest.PaymentMethods {
    
    struct MealVoucher: Encodable {
        
        let enable: Bool
        let maxAmount: Int64?
        
        enum CodingKeys: String, CodingKey {
            case enable
            case maxAmount = "max_amount_unit"
        }
        
        public init(enable: Bool = true, maxAmount: Int64?) {
            self.enable = enable
            self.maxAmount = maxAmount
        }
        
        public func encode(to encoder: Encoder) throws {
            var encoder = encoder.container(keyedBy: CodingKeys.self)
            try encoder.encode(enable, forKey: .enable)
            try encoder.encodeIfPresent(maxAmount, forKey: .maxAmount)
        }
        
    }
    
}
