//
//  ServerErrorResponse.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 10/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

public struct ServerErrorResponse: Decodable, Error {

    public let code: Int
    public let message: String
    public let wlt: String

}

extension ServerErrorResponse: CustomNSError {

    public var errorCode: Int {
        return code
    }

    public var errorUserInfo: [String: Any] {

        return [
            "message": message,
            "wlt": wlt
        ]

    }

}
