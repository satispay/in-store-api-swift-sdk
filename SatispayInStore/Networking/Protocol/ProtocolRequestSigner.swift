//
//  NetworkRequestSigner.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 10/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

/// Component responsible for signing HTTP requests.
struct ProtocolRequestSigner {

    private let keyId: String
    private let kMaster: Data
    private let sequenceNumber: Int

    private static let dateFormatter: DateFormatter = {

        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "GMT")
        formatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss z"
        formatter.locale = Locale(identifier: "en_US")

        return formatter

    }()

    init(keyId: String, kMaster: Data, sequenceNumber: Int) {

        self.keyId = keyId
        self.kMaster = kMaster
        self.sequenceNumber = sequenceNumber

    }

    /// Signs an URL request.
    ///
    /// - Parameter request: `URLRequest` to sign
    /// - Returns: Signed request
    /// - Throws: `ProtocolRequestSignerError`
    func signed(request: URLRequest) throws -> URLRequest {

        guard request.url != nil, request.httpMethod != nil else {
            throw ProtocolRequestSignerError.invalidRequest
        }

        guard let headers = try headers(for: request) else {
            return request
        }

        var signedRequest = request

        for (key, value) in headers {
            signedRequest.setValue(value, forHTTPHeaderField: key)
        }

        return signedRequest

    }

    // MARK: Headers generation
    private func headers(for request: URLRequest) throws -> [String: String]? {

        let dataHash = Hash.sha512(of: request.httpBody ?? Data()).digest.base64EncodedString()
        let date = ProtocolRequestSigner.dateFormatter.string(from: Date())

        let authParameters = [
            "keyId": keyId,
            "algorithm": "hmac-sha256",
            "satispayresign": "enable",
            "headers": "(request-target) host date digest",
            "signature": try signature(request: request, date: date, digest: "SHA-512=\(dataHash)"),
            "satispaysequence": String(sequenceNumber),
            "satispayperformance": "LOW"
        ]

        var paramsToJoin = [String]()

        for key in ["keyId", "algorithm", "satispayresign", "headers", "signature", "satispaysequence", "satispayperformance"] {

            guard let unwrappedValue = authParameters[key] else {
                continue
            }

            paramsToJoin.append("\(key)=\"\(unwrappedValue)\"")

        }

        let authHeader = paramsToJoin.joined(separator: ", ")

        return [
            "Date": date,
            "Digest": "SHA-512=\(dataHash)",
            "Authorization": "Signature \(authHeader)"
        ]

    }

    private func signature(request: URLRequest, date: String, digest: String) throws -> String {

        guard let target = request.url?.path, let host = request.url?.host, let method = request.httpMethod?.lowercased() else {
            throw ProtocolRequestSignerError.invalidRequest
        }

        let queryParamsString: String

        if let query = request.url?.query, query.count > 0 {
            queryParamsString = "?\(query)"
        } else {
            queryParamsString = ""
        }

        let parameters = [
            "(request-target)": "\(method) \(target)\(queryParamsString)",
            "host": host,
            "date": date,
            "digest": digest
        ]

        var paramsToJoin = [String]()

        for key in ["(request-target)", "host", "date", "digest"] {

            guard let unwrappedValue = parameters[key] else {
                continue
            }

            paramsToJoin.append("\(key): \(unwrappedValue)")

        }

        guard let dataToSign = paramsToJoin.joined(separator: "\n").data(using: .utf8) else {
            throw ProtocolRequestSignerError.signatureFailure
        }

        guard let kAuth = KeyDerivation.kAuth(withSequence: sequenceNumber, kMaster: kMaster) else {
            throw ProtocolRequestSignerError.signatureFailure
        }

        return HMAC.sha256(of: dataToSign, usingKey: kAuth).digest
            .base64EncodedString()
            .replacingOccurrences(of: "\n", with: "")

    }
}
