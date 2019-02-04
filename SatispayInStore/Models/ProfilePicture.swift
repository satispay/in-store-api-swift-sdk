//
//  ProfilePicture.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 04/02/2019.
//  Copyright © 2019 Pierluigi D'Andrea. All rights reserved.
//

import Foundation

public struct ProfilePicture: Decodable, Equatable {

    public let id: String
    public let url: URL
    public let width: Int?
    public let height: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case url
        case width
        case height
    }

    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        url = try container.decode(URL.self, forKey: .url)
        width = try? container.decode(Int.self, forKey: .width)
        height = try? container.decode(Int.self, forKey: .height)

    }

}
