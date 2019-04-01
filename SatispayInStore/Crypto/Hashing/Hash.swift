//
//  Hash.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 11/10/16.
//  Copyright © 2016 Satispay. All rights reserved.
//

import CommonCrypto
import Foundation

public enum Hash {

    /// Hash digest for the specified data.
    ///
    /// - note: The digest is re-computed every time the property is accessed
    public var digest: Data {
        switch self {
        case .sha1(let data):
            return Hash.digest(of: data, length: Int(CC_SHA1_DIGEST_LENGTH), using: CC_SHA1)
        case .sha256(let data):
            return Hash.digest(of: data, length: Int(CC_SHA256_DIGEST_LENGTH), using: CC_SHA256)
        case .sha512(let data):
            return Hash.digest(of: data, length: Int(CC_SHA512_DIGEST_LENGTH), using: CC_SHA512)
        }
    }

    case sha1(of: Data)
    case sha256(of: Data)
    case sha512(of: Data)

}

extension Hash {

    typealias DigestFunction = (_ data: UnsafeRawPointer, _ len: CC_LONG, _ md: UnsafeMutablePointer<UInt8>) -> UnsafeMutablePointer<UInt8>?

    /// Computes a generic digest of the `data` bytes.
    ///
    /// - parameter data:     Data to hash
    /// - parameter length:   Digest length
    /// - parameter function: Digest function
    private static func digest(of data: Data, length: Int, using function: DigestFunction) -> Data {

        let bytesCount = data.count

        return data.withUnsafeBytes { (pointer) -> Data in

            var digest = [UInt8](repeating: 0, count: length)
            _ = function(pointer.baseAddress!, CC_LONG(bytesCount), &digest)

            return Data(digest)

        }

    }

}
