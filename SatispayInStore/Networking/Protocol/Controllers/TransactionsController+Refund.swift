//
//  TransactionsController+Refund.swift
//  SatispayInStore-iOS
//
//  Created by Pierluigi D'Andrea on 24/11/17.
//  Copyright © 2017 Pierluigi D'Andrea. All rights reserved.
//

import Foundation

extension TransactionsController {

    /// Refund a transaction.
    ///
    /// - Parameters:
    ///   - transactionId: Id of the transaction to refund.
    public func refund(transactionId: String,
                       completionHandler: @escaping CompletionHandler<TransactionRefundResponse>) -> CancellableOperation {

        return TransactionsService.refund(id: transactionId).request { (response, _, error) in
            completionHandler(response, error)
        }

    }

}
