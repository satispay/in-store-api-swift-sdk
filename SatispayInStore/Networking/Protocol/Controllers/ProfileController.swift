//
//  ProfileController.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

public class ProfileController: NetworkController {

    /// Shop profile info.
    public func me(completionHandler: @escaping CompletionHandler<Profile>) -> CancellableOperation {

        return ProfileService.me.request { (response, _, error) in
            completionHandler(response, error)
        }

    }

    public func updateMe(acceptance: Acceptance, completionHandler: @escaping CompletionHandler<Profile>) -> CancellableOperation {
        
        let request = ProfileAcceptanceRequest(acceptance: acceptance)
        return ProfileService.acceptance(request: request).request { (response, _, error) in
            completionHandler(response, error)
        }
    }
}
