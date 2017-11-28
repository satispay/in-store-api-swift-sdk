//
//  DHController.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

public class DHController: NetworkController {

    private(set) lazy var dispatchQueue = DispatchQueue(label: "com.satispay.instoreapi.dh-parameters-generation-queue", qos: .default)

}
