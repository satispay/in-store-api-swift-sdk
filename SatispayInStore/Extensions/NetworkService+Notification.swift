//
//  NetworkService+Notification.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 16/11/17.
//  Copyright © 2017 Pierluigi D'Andrea. All rights reserved.
//

import Foundation

extension Notification.Name {

    public struct NetworkService {

        /// Event posted when a `URLRequest` is resumed.
        ///
        /// The `URLRequest` is sent in the `userInfo` dictionary using the `NetworkServiceNotificationKey.request` key.
        public static let didResume = Notification.Name(rawValue: "com.satispay.notification.name.task.didResume")

        /// Event posted when a `URLRequest` is cancelled.
        ///
        /// The `URLRequest` is also sent in the `userInfo` dictionary using the `NetworkServiceNotificationKey.request` key.
        public static let didCancel = Notification.Name(rawValue: "com.satispay.notification.name.task.didCancel")

        /// Event posted when a `URLRequest` completes.
        ///
        /// The `userInfo` dictionary constains the following keys:
        /// - `NetworkServiceNotificationKey.request`: `URLRequest`
        /// - `NetworkServiceNotificationKey.error`: if the request completed with an error
        public static let didComplete = Notification.Name(rawValue: "com.satispay.notification.name.task.didComplete")

    }

}

public struct NetworkServiceNotificationKey {

    public static let request = "com.satispay.notification.key.request"
    public static let response = "com.satispay.notification.key.response"
    public static let error = "com.satispay.notification.key.error"

}
