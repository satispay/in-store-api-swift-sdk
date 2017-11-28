//
//  DHExchangeRequest.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

public struct DHExchangeRequest: Encodable {

    let p: String
    let g: String
    let publicKey: String
    let language: String
    let country: String

    enum CodingKeys: String, CodingKey {

        case p
        case g
        case publicKey = "public_key"
        case language = "language_iso6391"
        case country = "country_iso3166"

    }

    public init?(params: DHParams) {

        guard let p = params.P, let g = params.G, let publicKey = params.publicKey else {
            return nil
        }

        self.p = p
        self.g = g
        self.publicKey = publicKey

        self.language = Locale.current.languageCode ?? "en"
        self.country = Locale.current.regionCode ?? "US"

    }

}
