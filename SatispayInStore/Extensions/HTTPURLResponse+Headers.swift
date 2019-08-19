//
//  HTTPURLResponse+Headers.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 19/08/2019.
//  Copyright © 2019 Pierluigi D'Andrea. All rights reserved.
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
