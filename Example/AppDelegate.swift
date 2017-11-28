//
//  AppDelegate.swift
//  Example
//
//  Created by Pierluigi D'Andrea on 23/11/17.
//  Copyright © 2017 Pierluigi D'Andrea. All rights reserved.
//

import SatispayInStore
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        //  use the test environment
        SatispayInStoreConfig.environment = StagingEnvironment()

        return true

    }

}
