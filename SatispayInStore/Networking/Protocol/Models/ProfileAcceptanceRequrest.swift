//
//  ProfileAcceptanceRequrest.swift
//  SatispayInStore-iOS
//
//  Created by Andrea Altea on 10/12/2019.
//  Copyright © 2019 Pierluigi D'Andrea. All rights reserved.
//

import Foundation

public struct ProfileAcceptanceRequest: Encodable {

    public let acceptance: Acceptance
    
    public init(acceptance: Acceptance) {
        self.acceptance = acceptance
    }
}
