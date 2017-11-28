//
//  NetworkService+Error.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 10/11/17.
//  Copyright © 2017 Pierluigi D'Andrea. All rights reserved.
//

import Foundation

public enum NetworkServiceError: Error {

    case any(Error?)
    case response(ServerErrorResponse)

}
