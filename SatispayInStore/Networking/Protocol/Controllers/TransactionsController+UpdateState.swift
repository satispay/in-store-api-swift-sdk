//
//  TransactionsController+UpdateState.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 13/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

extension TransactionsController {

    /// Approve or cancel a transaction.
    ///
    /// - Parameters:
    ///   - transactionId: Id of the transaction to approve/cancel.
    ///   - newState: State to set: `.approved` or `.cancelled`.
    public func updateState(of transactionId: String,
                            with newState: TransactionState,
                            completionHandler: @escaping CompletionHandler<TransactionStateUpdateResponse>) -> CancellableOperation {

        return TransactionsService.updateState(id: transactionId, request: .init(state: newState)).request { (response, _, error) in
            completionHandler(response, error)
        }

    }

}
