//
//  Environments.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 08/11/17.
//  Copyright © 2017 Pierluigi D'Andrea. All rights reserved.
//

import Foundation

public struct ProductionEnvironment: EnvironmentConfig {

    public let remoteHost = "authservices.satispay.com"

    public let publicKey = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvtDtFjcc2NbhoqJIJu7s\n" +
        "OUUEgrli4ehOQb2KBBNCHJlj22kyYfkZfx5CzBGZt8hNQYQHR0jAoLSiGm8lcLja\n" +
        "0D5Rt5WGl2Opgd9ubhhPxf7BTnkHEh2ZnTTI+7R55CVBPJ9xPFEcxEEhxsjChWaJ\n" +
        "q6iv2vldOn4PbQ/ent3nn1PUYvEkXQmT21c1c4MC2X8YW958/S1XqPTlPDxDUSwq\n" +
        "2O9L3aSqjej4vedmld+X0l5bdw9tT9YTWCGQsbzrWAidEagEpz22VxAR71ZsMYoV\n" +
        "Pnjj5mkVf8FUTwX4iUhyrM0mVEN7Ro0VhuYeFOoxKmP1OuKey1EMx879GuWSeIZG\n" +
        "GQIDAQAB"

    public let keychain = EnvironmentKeychainConfig(publicKey: .init(applicationTag: "ProtocolKeys.PublicKey"),
                                                    kSafe: .init(service: "Satispay", account: "kSafeApp"),
                                                    kMaster: .init(service: "Satispay", account: "kMaster"),
                                                    keyId: .init(service: "Satispay", account: "KeyId"),
                                                    sequenceNumber: .init(service: "Satispay", account: "SeqNo"))

    public let urlSession: URLSession

    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

}

public struct StagingEnvironment: EnvironmentConfig {

    public let remoteHost = "staging.authservices.satispay.com"

    public let publicKey = "MIIBITANBgkqhkiG9w0BAQEFAAOCAQ4AMIIBCQKCAQB3ywj4mFovtOHGqKY+fkeN\n" +
        "EJVvwVPCF8uiutVr0Q48UH5U1vmpeSS03ghKpAD8fGm7pgqUfp8vkBbKNvqvJyXv\n" +
        "DhyMFAtp6Dj8HEEuNXaBfcIIsIqHsXrHlXPUCXbolKoJk1K7Un0p2mV2r+NRQnEP\n" +
        "+V2SnDUEbJiz/eRRH/KNhnkKipJKCoOqgiMxkmZcymxfUN4zleiENqDs0jGbO9VR\n" +
        "Hnx8DWIJbYpFALsilDsd6gYzlQJy1x2hixYWNBS30pIDNu8+tempHuCYojz8Xre3\n" +
        "C3rICMmsMrQELxBVuFzLeli0592wL5uI/lFPzs0cFzp6NPpW11W47IgV4HH+wl65\n" +
        "AgMBAAE="

    public let keychain = EnvironmentKeychainConfig(publicKey: .init(applicationTag: "ProtocolKeys.PublicKey"),
                                                    kSafe: .init(service: "Satispay", account: "kSafeApp"),
                                                    kMaster: .init(service: "Satispay", account: "kMaster"),
                                                    keyId: .init(service: "Satispay", account: "KeyId"),
                                                    sequenceNumber: .init(service: "Satispay", account: "SeqNo"))

    public let urlSession: URLSession

    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

}

public struct TestEnvironment: EnvironmentConfig {

    public let remoteHost = "test.authservices.satispay.com"

    public let publicKey = "MIIBITANBgkqhkiG9w0BAQEFAAOCAQ4AMIIBCQKCAQB3ywj4mFovtOHGqKY+fkeN\n" +
        "EJVvwVPCF8uiutVr0Q48UH5U1vmpeSS03ghKpAD8fGm7pgqUfp8vkBbKNvqvJyXv\n" +
        "DhyMFAtp6Dj8HEEuNXaBfcIIsIqHsXrHlXPUCXbolKoJk1K7Un0p2mV2r+NRQnEP\n" +
        "+V2SnDUEbJiz/eRRH/KNhnkKipJKCoOqgiMxkmZcymxfUN4zleiENqDs0jGbO9VR\n" +
        "Hnx8DWIJbYpFALsilDsd6gYzlQJy1x2hixYWNBS30pIDNu8+tempHuCYojz8Xre3\n" +
        "C3rICMmsMrQELxBVuFzLeli0592wL5uI/lFPzs0cFzp6NPpW11W47IgV4HH+wl65\n" +
        "AgMBAAE="

    public let keychain = EnvironmentKeychainConfig(publicKey: .init(applicationTag: "ProtocolKeys.PublicKey"),
                                                    kSafe: .init(service: "Satispay", account: "kSafeApp"),
                                                    kMaster: .init(service: "Satispay", account: "kMaster"),
                                                    keyId: .init(service: "Satispay", account: "KeyId"),
                                                    sequenceNumber: .init(service: "Satispay", account: "SeqNo"))

    public let urlSession: URLSession

    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

}
