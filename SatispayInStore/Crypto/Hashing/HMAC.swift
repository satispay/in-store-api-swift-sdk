//
//  HMAC.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 17/10/16.
//  Copyright © 2016 Satispay. All rights reserved.
//

import CommonCrypto
import Foundation

public enum HMAC {

    /// HMAC digest for the specified data.
    ///
    /// - note: The digest is re-computed every time the property is accessed
    public var digest: Data {
        switch self {
        case .sha1(let data, let key):
            return HMAC.digest(of: data, with: key, length: Int(CC_SHA1_DIGEST_LENGTH), using: CCHmacAlgorithm(kCCHmacAlgSHA1))
        case .sha256(let data, let key):
            return HMAC.digest(of: data, with: key, length: Int(CC_SHA256_DIGEST_LENGTH), using: CCHmacAlgorithm(kCCHmacAlgSHA256))
        }
    }

    case sha1(of: Data, usingKey: Data)
    case sha256(of: Data, usingKey: Data)

}

extension HMAC {

    /// Computes an HMAC digest of the `data` bytes.
    ///
    /// - parameter data:     Data to hash
    /// - parameter length:   Digest length
    /// - parameter function: Digest function
    private static func digest(of data: Data, with key: Data, length: Int, using algorithm: CCHmacAlgorithm) -> Data {

        return data.withUnsafeBytes { (dataPointer) -> Data in
            return key.withUnsafeBytes { (keyPointer) -> Data in

                var digest = [UInt8](repeating: 0, count: length)
                CCHmac(algorithm, keyPointer.baseAddress, key.count, dataPointer.baseAddress, data.count, &digest)

                return Data(digest)

            }
        }

    }

}
