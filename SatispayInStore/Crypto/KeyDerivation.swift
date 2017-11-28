//
//  ProtocolCrypto.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 22/04/16.
//  Copyright © 2016 Satispay. All rights reserved.
//

import CommonCrypto
import Foundation

public struct KeyDerivation {

    public static func key(from password: Data, rounds: UInt32, length: Int = Int(kCCKeySizeAES128)) -> Data? {

        var key = Data(repeating: 0, count: length)
        var result = errSecSuccess

        password.withUnsafeBytes { (passwordPointer: UnsafePointer<UInt8>) -> Void in
            key.withUnsafeMutableBytes { (keyPointer: UnsafeMutablePointer<UInt8>) -> Void in
                passwordPointer.withMemoryRebound(to: Int8.self, capacity: password.count) { (passwordDataPointer) -> Void in
                    result = CCKeyDerivationPBKDF(CCPBKDFAlgorithm(kCCPBKDF2),
                                                  passwordDataPointer,
                                                  password.count,
                                                  passwordPointer,
                                                  password.count,
                                                  CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA1),
                                                  rounds,
                                                  keyPointer,
                                                  length)
                }
            }
        }

        guard result == errSecSuccess else {
            return nil
        }

        return key

    }

    public static func kSess(withSequence sequence: Int, kMaster: Data, derivationRounds: UInt32 = 2617) -> Data? {

        let password = OTP.generate(secret: kMaster, step: Int64(sequence * 2) - 1, digits: 8)

        guard let passwordData = password?.data(using: .utf8) else {
            return nil
        }

        return key(from: passwordData, rounds: derivationRounds)

    }

    public static func kAuth(withSequence sequence: Int, kMaster: Data, derivationRounds: UInt32 = 2617) -> Data? {

        let password = OTP.generate(secret: kMaster, step: Int64(sequence * 2), digits: 8)

        guard let passwordData = password?.data(using: .utf8) else {
            return nil
        }

        return key(from: passwordData, rounds: derivationRounds)

    }

}
