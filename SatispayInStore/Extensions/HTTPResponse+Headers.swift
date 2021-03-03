//
//  HTTPResponse.swift
//  SatispayInStore
//
//  Created by Andrea Altea on 03/03/21.
//  Copyright © 2021 Pierluigi D'Andrea. All rights reserved.
//

import Foundation

extension HTTPURLResponse {

    func value(forHeaderField field: String) -> Any? {
        for (key, value) in allHeaderFields {
            guard (key as? String)?.caseInsensitiveCompare(field) == .orderedSame else {
                continue
            }

            return value
        }

        return nil
    }

}
