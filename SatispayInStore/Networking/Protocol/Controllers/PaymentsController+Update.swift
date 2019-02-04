//
//  PaymentsController+Update.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 13/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

extension PaymentsController {

    /// Approve or cancel a transaction.
    ///
    /// - Parameters:
    ///   - id: Id of the payment to update.
    ///   - action: Update action to perform.
    public func updatePayment(id: String,
                              action: PaymentUpdateAction,
                              completionHandler: @escaping CompletionHandler<Payment>) -> CancellableOperation {

        return PaymentsService.updatePayment(id: id, request: .init(action: action)).request { (response, _, error) in
            completionHandler(response, error)
        }

    }

}
