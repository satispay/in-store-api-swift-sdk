//
//  ShopsController.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import CoreLocation
import Foundation

public class ShopsController: NetworkController {

    /// Update the location of the shop.
    ///
    /// - Parameters:
    ///   - shopId
    ///   - coordinate: New location
    public func updateLocation(shopId: String,
                               coordinate: CLLocationCoordinate2D,
                               completionHandler: @escaping CompletionHandler<UpdateLocationResponse>) -> CancellableOperation {

        return ShopsService.updateLocation(shopId: shopId, request: .init(coordinate: coordinate)).request { (response, _, error) in
            completionHandler(response, error)
        }

    }

}
