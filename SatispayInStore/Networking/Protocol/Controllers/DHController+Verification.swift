//
//  DHController+Verification.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation
import OpenSSL

extension DHController {

    /// Completes the DH and enables the device using the activation token.
    ///
    /// - Parameters:
    ///   - context: `Context` struct returned by `challenge(parameters:exchangeResponse:completionHandler:)`.
    ///   - challengeResponse: Response of `challenge(parameters:exchangeResponse:completionHandler:)`.
    ///   - token: Activation token.
    public func verification(context: Context,
                             challengeResponse: DHChallengeResponse,
                             token: String,
                             completionHandler: @escaping (NetworkServiceError?) -> Void) -> CancellableOperation? {

        do {

            guard let nonceNumber = BigInteger(string: challengeResponse.nonce) else {
                throw DHError.verificationFailure
            }

            //  1. increment the nonce
            let nonce = nonceNumber + 1

            //  2. generate a random password
            var randomKey = [UInt8](repeating: 0, count: 32)

            guard SecRandomCopyBytes(kSecRandomDefault, 32, &randomKey) == 0 else {
                throw DHError.verificationFailure
            }

            //  3. derivate a key from the password
            guard let key = KeyDerivation.key(from: Data(bytes: UnsafePointer<UInt8>(randomKey), count: randomKey.count), rounds: 2617) else {
                throw DHError.verificationFailure
            }

            //  4. split the key in half
            let left = Data(key.prefix(upTo: key.count / 2))
            let right = Data(key.suffix(from: key.count / 2))

            //  5. make the new nonce: (nonce + 1)(right)
            guard let replyNonce = nonce?.string, var replyNonceData = replyNonce.data(using: String.Encoding.utf8) else {
                throw DHError.verificationFailure
            }

            replyNonceData.append(right)

            //  6. SHA256(replyNonceData)
            let nonceHash = Hash.sha256(of: replyNonceData as Data).digest

            guard let kAuth = context.kAuth, let kSess = context.kSess else {
                throw DHError.cannotComputeSharedSecret
            }

            let encryptedRequest = try DHEncryptedRequest(keyId: context.keyId,
                                                          kAuth: kAuth,
                                                          kSess: kSess,
                                                          payload: DHVerificationRequest(nonce: nonceHash, kSafe: right, token: token))

            return DHService.verify(request: encryptedRequest).request(mapping: { (data) -> DHVerificationResponse in

                let encrypted: DHEncryptedResponse = try NetworkController.attemptDecode(of: data)
                let data = try encrypted.decrypt(kSess: kSess, kAuth: kAuth)
                let response: DHVerificationResponse = try NetworkController.attemptDecode(of: data)

                guard response.response == "OK" else {
                    throw DHError.tokenVerificationFailure
                }

                try context.saveKeys(with: left)

                return response

            }, completionHandler: { (_, _, error) in

                completionHandler(error)

            })

        } catch let error {

            completionHandler(.any(error))
            return nil

        }

    }

}
