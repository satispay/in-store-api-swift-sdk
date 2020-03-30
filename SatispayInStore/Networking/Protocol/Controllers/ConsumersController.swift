//
//  CustomersController.swift
//  SatispayInStore
//
//  Created by Andrea Altea on 27/03/2020.
//  Copyright © 2020 Pierluigi D'Andrea. All rights reserved.
//

import Foundation

public class ConsumersController: NetworkController {

    public func consumer(phoneNumber: String, completionHandler: @escaping CompletionHandler<ConsumerResponse>) -> CancellableOperation {
        
        return ConsumersService.consumer(phoneNumber: phoneNumber).request { (response, _, error) in
            completionHandler(response, error)
        }
    }
}
