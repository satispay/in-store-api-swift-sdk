//
//  DevicesController.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

public class DevicesController: NetworkController {

    /// Registers a device with the server.
    ///
    /// - Parameters:
    ///   - pushToken: Remote notifications device token or `nil`.
    public func updateDevice(pushToken: String?,
                             completionHandler: @escaping CompletionHandler<UpdateDeviceResponse>) -> CancellableOperation {

        return DevicesService.updateDevice(request: .init(pushToken: pushToken)).request { (response, _, error) in
            completionHandler(response, error)
        }

    }

}
