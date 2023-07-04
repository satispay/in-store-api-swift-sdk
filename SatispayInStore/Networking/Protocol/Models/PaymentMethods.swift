//
//  PaymentMethods.swift
//  SatispayInStore
//
//  Created by Davide Ceresola on 04/07/23.
//  Copyright © 2023 Pierluigi D'Andrea. All rights reserved.
//

import Foundation

public struct PaymentMethods: Encodable {
    
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

public extension PaymentMethods {
    
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
