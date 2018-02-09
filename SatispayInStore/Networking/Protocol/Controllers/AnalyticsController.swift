//
//  AnalyticsController.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

public class AnalyticsController: NetworkController {

    /// API that provides the sequence number as a response.
    /// - Note: A client must call this method before sending any other signed request.
    ///
    /// - Parameters:
    ///   - udid: Unique identifier of the device (if any).
    ///   - language: ISO-639 language code.
    ///   - deviceInfo: Device model name.
    ///   - appVersion: App version number.
    public func started(udid: String?,
                        language: String = Locale.current.languageCode ?? "en",
                        deviceInfo: String,
                        appVersion: String,
                        completionHandler: @escaping CompletionHandler<StartedResponse>) -> CancellableOperation {

        let request = StartedRequest(udid: udid, language: language, deviceInfo: deviceInfo, appVersion: appVersion)

        return AnalyticsService.started(request: request).request { (response: StartedResponse?, _, error) in

            if case .some(.response(let errorResponse)) = error, errorResponse.code == 35,
                let sequence: Int = try? Keychain.find(entry: SatispayInStoreConfig.environment.keychain.sequenceNumber) {

                try? Keychain.insert(entry: SatispayInStoreConfig.environment.keychain.sequenceNumber, value: sequence + 2)

            }

            completionHandler(response, error)

        }

    }

}
