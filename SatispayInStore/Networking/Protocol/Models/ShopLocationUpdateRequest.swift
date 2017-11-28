//
//  ShopLocationUpdateRequest.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import CoreLocation
import Foundation

public struct ShopLocationUpdateRequest: Encodable {

    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees

    public init(coordinate: CLLocationCoordinate2D) {

        latitude = coordinate.latitude
        longitude = coordinate.longitude

    }

}
