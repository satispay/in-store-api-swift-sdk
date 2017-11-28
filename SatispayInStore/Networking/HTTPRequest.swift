//
//  HTTPRequest.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 08/11/17.
//  Copyright © 2017 Pierluigi D'Andrea. All rights reserved.
//

import Foundation

public class HTTPRequest: CancellableOperation {

    let urlRequest: URLRequest
    var cancellation: (() -> Void)?

    private weak var dataTask: URLSessionDataTask?

    init(urlRequest: URLRequest) {

        self.urlRequest = urlRequest

    }

    func resume(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {

        dataTask = SatispayInStoreConfig.environment.urlSession.dataTask(with: urlRequest, completionHandler: completionHandler)
        dataTask?.resume()

    }

    public func cancel() {

        dataTask?.cancel()
        cancellation?()

    }

}
