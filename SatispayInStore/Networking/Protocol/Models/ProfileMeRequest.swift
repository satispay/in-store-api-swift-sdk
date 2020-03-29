//
//  ProfileMeRequest.swift
//  SatispayInStore
//
//  Created by Andrea Altea on 29/03/2020.
//  Copyright © 2020 Pierluigi D'Andrea. All rights reserved.
//

import Foundation

public struct ProfileMeRequest {
    public var softwareName: String
    public var softwareHouse: String
    
    public init(softwareName: String, softwareHouse: String) {
        self.softwareName = softwareName
        self.softwareHouse = softwareHouse
    }
}
