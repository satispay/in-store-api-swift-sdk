//
//  TransactionsController.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import CoreLocation
import Foundation

extension TransactionsController {

    /// Retrieve the transaction history sorted by date (from newer to older).
    ///
    /// - Parameters:
    ///   - filter: Use `proposed` to get only pending transactions.
    ///   - offset: Cursor for use in pagination. This is the transaction_id that defines your place in the list.
    ///             For instance, if you make a list request and receive 100 objects, ending with `1204`,
    ///             your subsequent call can include `1204` as offset in order to fetch the next page of the list.
    ///   - limit: Number of objects to be returned, between 1 and 100.
    ///   - analytics: Device and client info.
    public func transactions(filter: String? = nil,
                             offset: String? = nil,
                             limit: UInt? = nil,
                             analytics: TransactionsListRequest.Analytics,
                             completionHandler: @escaping CompletionHandler<PaginatedResponse<Transaction>>) -> CancellableOperation {

        let request = TransactionsListRequest(filter: filter, offset: offset, limit: limit)

        return TransactionsService.list(request: request, analytics: analytics).request { (response, _, error) in
            completionHandler(response, error)
        }

    }

}
