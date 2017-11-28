//
//  RSA.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 17/10/16.
//  Copyright © 2016 Satispay. All rights reserved.
//

import CommonCrypto
import Foundation

public class RSA {

    /**
     Encrypts a string.

     - parameter string:     String to encrypt
     - parameter keyTagName: Name of the encryption key to read from the keychain
     - parameter keyClass:   Class of the encryption key to read from the keychain

     - throws: CryptoError if the string cannot be encrypted or the key is not available

     - returns: Encrypted data
     */
    public static func encrypt(string: String, using key: Keychain.KeyEntry) throws -> Data {

        guard let encryptionData = string.data(using: .ascii) else {
            throw CryptoError.malformedData
        }

        return try encrypt(data: encryptionData, using: key)

    }

    /**
     Encrypts a Data struct.

     - parameter data:          Data to encrypt
     - parameter keyTagName:    Name of the encryption key to read from the keychain
     - parameter keyClass:      Class of the encryption key to read from the keychain

     - throws: CryptoError if the data cannot be encrypted or the key is not available

     - returns: Encrypted data
     */
    public static func encrypt(data: Data, using key: Keychain.KeyEntry) throws -> Data {

        let keyRef = try Keychain.find(entry: key)

        let blockSize = SecKeyGetBlockSize(keyRef)
        var encryptedData = Data(repeating: 0, count: blockSize)
        var encryptedDataLength = blockSize

        var result = errSecSuccess

        data.withUnsafeBytes { (dataPointer) -> Void in
            encryptedData.withUnsafeMutableBytes { (encryptedDataPointer) -> Void in
                result = SecKeyEncrypt(keyRef,
                                       .PKCS1,
                                       dataPointer,
                                       data.count,
                                       encryptedDataPointer,
                                       &encryptedDataLength)
            }
        }

        guard result == errSecSuccess else {
            throw CryptoError.encryptionFailure(result)
        }

        return Data(encryptedData.prefix(upTo: encryptedDataLength))

    }

}
