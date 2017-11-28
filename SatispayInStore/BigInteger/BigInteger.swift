//
//  BigInteger.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 18/10/16.
//  Copyright © 2016 Satispay. All rights reserved.
//

import Foundation
import OpenSSL

/// Arbitrary precision integer.
public class BigInteger {

    /// Under the hood `BigInteger` is represented as an OpenSSL `BIGNUM`.
    private(set) var representation: UnsafeMutablePointer<BIGNUM>

    /// String representation as a decimal number.
    public var string: String? {

        var number = representation

        guard let chars = BN_bn2dec(number) else {
            return nil
        }

        defer {
            CRYPTO_free(chars)
        }

        return String(cString: chars)

    }

    /// Initializes a BigInteger with its BIGNUM representation.
    public init?(_ bigNum: UnsafePointer<BIGNUM>) {

        guard let dup = BN_dup(bigNum) else {
            return nil
        }

        representation = BN_dup(dup)

    }

    /// Initializes a BigInteger with its String representation.
    public init?(string: String) {

        let value = string.utf8CString.withUnsafeBufferPointer { pointer -> UnsafeMutablePointer<BIGNUM>? in

            var num = BN_new()

            guard BN_dec2bn(&num, UnsafePointer<Int8>(pointer.baseAddress)) > 0 else {
                BN_free(num)
                return nil
            }

            guard num != nil else {
                BN_free(num)
                return nil
            }

            return num

        }

        guard let number = value else {
            return nil
        }

        representation = number

    }

    deinit {
        BN_free(representation)
    }

    /// Increments the value by `increment`.
    ///
    /// - parameter number:     Number to increment
    /// - parameter increment:  Increment amount
    public static func + (number: BigInteger, increment: UInt32) -> BigInteger? {

        let representation = BN_dup(number.representation)

        #if arch(x86_64)
        BN_add_word(representation, UInt(increment))
        #else
        BN_add_word(representation, increment)
        #endif

        return BigInteger(representation!)

    }

}
