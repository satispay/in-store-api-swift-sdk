//
//  PaymentsController+Payments.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import CoreLocation
import Foundation

extension PaymentsController {

    /// Retrieve the transaction history sorted by date (from newer to older).
    ///
    /// - Parameters:
    ///   - status: Use `PENDING` to get only pending transactions.
    ///   - offset: Cursor for use in pagination. This is the transaction_id that defines your place in the list.
    ///             For instance, if you make a list request and receive 100 objects, ending with `1204`,
    ///             your subsequent call can include `1204` as offset in order to fetch the next page of the list.
    ///   - limit: Number of objects to be returned, between 1 and 100.
    ///   - analytics: Device and client info.
    public func payments(status: Payment.Status? = nil,
                         startingAfter: String? = nil,
                         limit: UInt? = nil,
                         analytics: PaymentsListRequest.Analytics,
                         completionHandler: @escaping CompletionHandler<PaginatedDataResponse<Payment>>) -> CancellableOperation {

        let request = PaymentsListRequest(status: status, startingAfter: startingAfter, limit: limit)

        return PaymentsService.payments(request: request, analytics: analytics).request { (response, _, error) in
            completionHandler(response, error)
        }

    }

}
