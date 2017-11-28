//
//  DHParams.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 21/04/16.
//  Copyright © 2016 Satispay. All rights reserved.
//

import Foundation
import OpenSSL

public class DHParams {

    private let parameters: UnsafeMutablePointer<DH>

    private(set) lazy var P: String? = BigInteger(self.parameters.pointee.p)?.string
    private(set) lazy var G: String? = BigInteger(self.parameters.pointee.g)?.string
    private(set) lazy var publicKey: String? = BigInteger(self.parameters.pointee.pub_key)?.string

    init?(parameters: UnsafeMutablePointer<DH>) {

        var codes: Int32 = 0

        guard DH_check(parameters, &codes) == 1 else {
            return nil
        }

        guard (codes & DH_CHECK_P_NOT_SAFE_PRIME) == 0 &&
            (codes & DH_NOT_SUITABLE_GENERATOR) == 0 else {
            return nil
        }

        self.parameters = parameters

    }

    deinit {

        DH_free(parameters)

    }

    func sharedSecret(_ serverPublicKey: String) -> Data? {

        guard let publicKeyNum = BigInteger(string: serverPublicKey) else {
            return nil
        }

        var codes: Int32 = 0

        guard DH_check_pub_key(parameters, publicKeyNum.representation, &codes) == 1 else {
            return nil
        }

        guard (codes & DH_CHECK_PUBKEY_INVALID) == 0 &&
            (codes & DH_CHECK_PUBKEY_TOO_SMALL) == 0 else {
            return nil
        }

        let keySize = DH_size(parameters)
        let buffer = [UInt8](repeating: 0, count: Int(keySize))

        guard DH_compute_key(UnsafeMutablePointer(mutating: buffer), publicKeyNum.representation, parameters) > 0 else {
            return nil
        }

        return Hash.sha1(of: Data(bytes: UnsafePointer<UInt8>(buffer), count: Int(keySize))).digest

    }

}
