//
//  AES.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 17/10/16.
//  Copyright © 2016 Satispay. All rights reserved.
//

import CommonCrypto
import Foundation

public struct AES {

    /// Encrypts the specified data.
    ///
    /// - Parameters:
    ///   - data: Data to encrypt
    ///   - key: Encryption key
    ///
    /// - Returns: Encrypted data
    ///
    /// - Throws: `CryptoError.encryptionFailure`
    public static func encrypt(data: Data, usingKey key: Data) throws -> Data {
        return try crypt(algorithm: CCAlgorithm(kCCAlgorithmAES),
                         operation: CCOperation(kCCEncrypt),
                         key: key,
                         data: data)
    }

    /// Decrypts the specified data.
    ///
    /// - Parameters:
    ///   - data: Data to decrypt
    ///   - key: Decryption key
    ///
    /// - Returns: Decrypted data
    ///
    /// - Throws: `CryptoError.decryptionFailure`
    public static func decrypt(data: Data, usingKey key: Data) throws -> Data {
        return try crypt(algorithm: CCAlgorithm(kCCAlgorithmAES),
                         operation: CCOperation(kCCDecrypt),
                         key: key,
                         data: data)
    }

}

extension AES {

    /**
     Performs a CCOperation operation on `data` using `key`.

     - parameter algorithm: Operation algorithm
     - parameter operation: Operation to perform, kCCEncrypt or kCCDecrypt
     - parameter key:       Key to use to encrypt/decrypt
     - parameter data:      Data to encrypt/decrypt

     - returns: Data resulting from the operation
     */
    private static func crypt(algorithm: CCAlgorithm, operation: CCOperation, key: Data, data: Data) throws -> Data {

        var outData = Data(repeating: 0, count: data.count + kCCBlockSizeAES128)
        let outDataLength = outData.count

        var outDataFinalLength: Int = 0

        var status = CCCryptorStatus(kCCSuccess)

        data.withUnsafeBytes { (dataPointer) -> Void in
            key.withUnsafeBytes { (keyPointer) -> Void in
                outData.withUnsafeMutableBytes { (outDataPointer) -> Void in
                    status = CCCrypt(operation,
                                     algorithm,
                                     CCOptions(kCCOptionPKCS7Padding),
                                     keyPointer.baseAddress,
                                     key.count,
                                     nil,
                                     dataPointer.baseAddress,
                                     data.count,
                                     outDataPointer.baseAddress,
                                     outDataLength,
                                     &outDataFinalLength)
                }
            }
        }

        guard status == CCCryptorStatus(kCCSuccess) else {
            if operation == CCOperation(kCCEncrypt) {
                throw CryptoError.encryptionFailure(status)
            } else {
                throw CryptoError.decryptionFailure(status)
            }
        }

        return Data(outData.prefix(upTo: outDataFinalLength))

    }

}
