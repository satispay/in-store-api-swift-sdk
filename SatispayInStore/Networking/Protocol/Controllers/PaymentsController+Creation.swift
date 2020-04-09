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
    ///
    /// - Parameters:
    ///   - flow: Type of payment.
    ///   - amountUnit: Amount of the payment in cents.
    ///   - currency: Currency of the payment.
    ///   - expirationDate: Expiration date of the payment.
    ///   - metadata: Generic `Encodable` object containing additional info to be stored with the payment.
    ///   - callbackURL: URL that will be called when the Payment changes state.
    ///   - parentPaymentUid: Unique ID of the payment to refund (required when flow is `.refund`).
    ///   - idempotencyKey: Unique key to perform an idempotent request or nil.
    public func createPayment(flow: PaymentCreationRequest.Flow,
                              amountUnit: Int,
                              currency: String,
                              expirationDate: Date?,
                              metadata: PaymentCreationRequest.Metadata?,
                              callbackURL: URL?,
                              parentPaymentUid: String?,
                              consumerUid: String?,
                              paymentDescription: String?,
                              idempotencyKey: String?,
                              completionHandler: @escaping CompletionHandler<Payment>) -> CancellableOperation {

        let request = PaymentCreationRequest(flow: flow,
                                             amountUnit: amountUnit,
                                             currency: currency,
                                             expirationDate: expirationDate,
                                             metadata: metadata,
                                             callbackURL: callbackURL,
                                             parentPaymentUid: parentPaymentUid,
                                             consumerUid: consumerUid,
                                             paymentDescription: paymentDescription)

        return PaymentsService.createPayment(request: request, idempotencyKey: idempotencyKey).request { (response, _, error) in
            completionHandler(response, error)
        }

    }

}
