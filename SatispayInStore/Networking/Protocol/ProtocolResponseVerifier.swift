//
//  ResponseVerifier.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 10/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

struct ProtocolResponseVerifier {

    private let kMaster: Data
    private let sequenceNumber: Int

    init(kMaster: Data, sequenceNumber: Int) {

        self.kMaster = kMaster
        self.sequenceNumber = sequenceNumber

    }

    func verify(response: (Data, URLResponse)) throws {

        let (data, urlResponse) = response

        try validateSignature(urlResponse as! HTTPURLResponse, data: data)
        try validateDigest(urlResponse as! HTTPURLResponse, data: data)

    }

    func verify(data: Data, response: URLResponse) throws {

        try validateSignature(response as! HTTPURLResponse, data: data)
        try validateDigest(response as! HTTPURLResponse, data: data)

    }

    private func parseAuthenticationHeader(_ string: String) -> [String: String] {

        let elementSeparator = ","
        let keyValueSeparator = "="

        var stringToSplit = string

        if stringToSplit.hasPrefix("Signature") {
            stringToSplit = String(stringToSplit.dropFirst("Signature".count))
        }

        stringToSplit = stringToSplit.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if stringToSplit.hasPrefix(elementSeparator) {
            stringToSplit = String(stringToSplit.dropFirst(1))
        }

        var parameters = [String: String]()

        let scanner = Scanner(string: stringToSplit)

        while !scanner.isAtEnd {

            var key: NSString? = nil
            var value: NSString? = nil

            scanner.scanUpTo(keyValueSeparator, into: &key)
            scanner.scanString(keyValueSeparator, into: nil)

            scanner.scanUpTo(elementSeparator, into: &value)
            scanner.scanString(elementSeparator, into: nil)

            guard let scannedKey = key as String?,
                var scannedValue = value as String? else {
                    continue
            }

            if let clearValueRegex = try? NSRegularExpression(pattern: "^(\"+)|(\"+)$", options: .caseInsensitive) {
                let matchRange = NSRange(location: 0, length: scannedValue.count)
                scannedValue = clearValueRegex.stringByReplacingMatches(in: scannedValue,
                                                                        options: [],
                                                                        range: matchRange,
                                                                        withTemplate: "")
            }

            parameters.updateValue(scannedValue, forKey: scannedKey)

        }

        return parameters
    }

    private func validateSignature(_ response: HTTPURLResponse, data: Data) throws {

        guard let authenticate = response.allHeaderFields["Www-Authenticate"] as? String else {
            throw ProtocolResponseVerifierError.malformedResponse
        }

        let auth = parseAuthenticationHeader(authenticate)

        guard let algorithm = auth["algorithm"],
            let signatureString = auth["signature"],
            let signature = Data(base64Encoded: signatureString, options: []),
            let headers = auth["headers"]?.components(separatedBy: " ") else {
            throw ProtocolResponseVerifierError.malformedResponse
        }

        let toSign = headers.flatMap({ name -> String? in

            for (key, value) in response.allHeaderFields {

                if (key as? String)?.caseInsensitiveCompare(name) == .orderedSame {
                    return "\(name): \(value)"
                }

            }

            return nil

        }).joined(separator: "\n")

        guard let dataToSign = toSign.data(using: String.Encoding.utf8) else {
            throw ProtocolResponseVerifierError.malformedResponse
        }

        //  Update the sequence number
        var currentSequence = sequenceNumber

        if let sequenceString = auth["satispaysequence"], let sequence = Int(sequenceString) {
            try Keychain.insert(entry: SatispayInStoreConfig.environment.keychain.sequenceNumber, value: sequence)
            currentSequence = sequence
        }

        guard let kAuth = KeyDerivation.kAuth(withSequence: currentSequence, kMaster: kMaster) else {
            throw ProtocolResponseVerifierError.invalidSignature
        }

        let hmac: Data

        switch algorithm {
        case "hmac-sha1":
            hmac = HMAC.sha1(of: dataToSign, usingKey: kAuth).digest
        case "hmac-sha256":
            hmac = HMAC.sha256(of: dataToSign, usingKey: kAuth).digest
        default:
            throw ProtocolResponseVerifierError.invalidSignature
        }

        guard signature == hmac else {
            throw ProtocolResponseVerifierError.invalidSignature
        }

    }

    private func validateDigest(_ response: HTTPURLResponse, data: Data) throws {

        //  Check whether the digest can be verified
        guard let digest = response.allHeaderFields["Digest"] as? String, digest.components(separatedBy: "=").count > 1,
            let digestAlgorithm = digest.components(separatedBy: "=").first?.uppercased() else {

            throw ProtocolResponseVerifierError.malformedResponse

        }

        //  Compute the hash digest
        let computedDigest: Data

        switch digestAlgorithm {
        case "SHA-1":
            computedDigest = Hash.sha1(of: data).digest
        case "SHA-256":
            computedDigest = Hash.sha256(of: data).digest
        case "SHA-512":
            computedDigest = Hash.sha512(of: data).digest
        default:
            throw ProtocolResponseVerifierError.malformedResponse
        }

        //  Decode the header digest value
        guard digest.count > digestAlgorithm.count + 1 else {
            throw ProtocolResponseVerifierError.digestMismatch
        }

        let digestString = digest[digest.index(digest.startIndex, offsetBy: digestAlgorithm.count + 1)...]
        let digestData = Data(base64Encoded: String(digestString), options: .ignoreUnknownCharacters)

        guard digestData == computedDigest else {
            throw ProtocolResponseVerifierError.digestMismatch
        }

    }

}
