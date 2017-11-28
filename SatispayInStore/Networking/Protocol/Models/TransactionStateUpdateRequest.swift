//
//  TransactionStateUpdateRequest.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 13/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

public struct TransactionStateUpdateRequest: Encodable {

    let state: TransactionState

    public init(state: TransactionState) {
        self.state = state
    }

}
