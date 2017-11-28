//
//  NavigationController.swift
//  Example
//
//  Created by Pierluigi D'Andrea on 24/11/17.
//  Copyright © 2017 Pierluigi D'Andrea. All rights reserved.
//

import SatispayInStore
import UIKit

class NavigationController: UINavigationController, ProfileRequiring {

    func configure(with profile: Profile) {

        for controller in viewControllers {
            (controller as? ProfileRequiring)?.configure(with: profile)
        }

    }

}
