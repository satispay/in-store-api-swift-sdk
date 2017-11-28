//
//  UIDevice+Model.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 27/09/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import UIKit

extension UIDevice {

    /// Name of the current device model.
    var modelName: String {

        var systemInfo = utsname()
        uname(&systemInfo)

        if let machine = NSString(bytes: &systemInfo.machine, length: Int(_SYS_NAMELEN), encoding: String.Encoding.ascii.rawValue)?.utf8String,
            let modelName = String(validatingUTF8: machine) {
            return modelName
        } else {
            return UIDevice.current.model
        }

    }

}
