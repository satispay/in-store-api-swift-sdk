//
//  DHController+Parameters.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation
import OpenSSL

extension DHController {

    /// Generates the Diffie-Hellman compliant big Integers P, G and PublicKey.
    public func generateParameters(completionHandler: @escaping CompletionHandler<DHParams>) -> CancellableOperation {

        let workItem = DispatchWorkItem {

            do {

                guard let dsaParams = DSA_new() else {
                    throw DHError.cannotGenerateParameters
                }

                defer {
                    DSA_free(dsaParams)
                }

                guard DSA_generate_parameters_ex(dsaParams, 1024, nil, 0, nil, nil, nil) == 1 else {
                    throw DHError.cannotGenerateParameters
                }

                let dhParams = DSA_dup_DH(dsaParams)

                guard dhParams != nil else {
                    throw DHError.cannotGenerateParameters
                }

                guard DH_generate_key(dhParams) == 1 else {
                    DH_free(dhParams)
                    throw DHError.cannotGenerateParameters
                }

                guard let params = DHParams(parameters: dhParams!) else {
                    DH_free(dhParams)
                    throw DHError.invalidDHParams
                }

                DispatchQueue.main.async {
                    completionHandler(params, nil)
                }

            } catch let error {

                DispatchQueue.main.async {
                    completionHandler(nil, .any(error))
                }

            }

        }

        dispatchQueue.async(execute: workItem)

        return workItem

    }

}
