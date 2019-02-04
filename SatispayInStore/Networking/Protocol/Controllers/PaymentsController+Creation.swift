//
//  PaymentsController+Creation.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 04/02/2019.
//  Copyright © 2019 Pierluigi D'Andrea. All rights reserved.
//

import Foundation

extension PaymentsController {

    /// Create a payment.
    public func createPayment(flow: PaymentCreationRequest.Flow,
                              amountUnit: Int,
                              currency: String,
                              expirationDate: Date?,
                              metadata: PaymentCreationRequest.Metadata?,
                              callbackURL: URL?,
                              parentPaymentUid: String?,
                              completionHandler: @escaping CompletionHandler<Payment>) -> CancellableOperation {


        let request = PaymentCreationRequest(flow: flow,
                                             amountUnit: amountUnit,
                                             currency: currency,
                                             expirationDate: expirationDate,
                                             metadata: metadata,
                                             callbackURL: callbackURL,
                                             parentPaymentUid: parentPaymentUid)

        return PaymentsService.createPayment(request: request).request { (response, _, error) in
            completionHandler(response, error)
        }

    }

}
