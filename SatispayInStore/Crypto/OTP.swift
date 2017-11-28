//
//  OTP.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 07/11/17.
//  Copyright © 2017 Pierluigi D'Andrea. All rights reserved.
//

import Foundation

public struct OTP {

    /// Computes a counter base OTP.
    ///
    /// - parameter secret: Secret key
    /// - parameter step:   Computation steps
    /// - parameter digits: Number of key digits
    ///
    /// - returns: Password
    public static func generate(secret: Data, step: Int64, digits: Int) -> String? {

        var buffer = [UInt8](repeating: 0, count: 8)
        var stepValue = step

        for i in (0..<buffer.count).reversed() {
            buffer[i] = UInt8(stepValue & 0xff)
            stepValue = stepValue >> 8
        }

        let hash = HMAC.sha1(of: Data(bytes: buffer), usingKey: secret).digest

        let offset = Int(hash[hash.count - 1]) & 0xf

        let hi = ((Int(hash[offset]) & 0x7f) << 24) | ((Int(hash[offset + 1]) & 0xff) << 16)
        let lo = ((Int(hash[offset + 2]) & 0xff) << 8) | (Int(hash[offset + 3]) & 0xff)

        let binary = hi | lo

        let otp = binary % Int(pow(10, Double(digits)))
        let otpString = String(otp)

        if digits - otpString.count > 0 {
            let padding = [String](repeating: "0", count: digits - otpString.count)
            return padding.joined() + otpString
        }

        return otpString

    }

}
