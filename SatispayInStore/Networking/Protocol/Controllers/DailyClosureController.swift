//
//  DailyClosureController.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 31/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

public class DailyClosureController: NetworkController {

    /// Retrieve the shop/device daily amount collected.
    ///
    /// - Parameters:
    ///   - day: Day to request (formatted as: `YYYYmmDD`)
    ///   - type: Type of daily closure requested.
    public func closure(day: String,
                        type: DailyClosureResponse.Kind,
                        completionHandler: @escaping CompletionHandler<DailyClosureResponse>) -> CancellableOperation {

        return DailyClosureService.closure(day: day, type: type).request { (response, _, error) in
            completionHandler(response, error)
        }

    }

}
