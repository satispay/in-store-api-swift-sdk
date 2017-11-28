//
//  PaginatedResponse.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 09/10/17.
//  Copyright © 2017 Satispay. All rights reserved.
//

import Foundation

public struct PaginatedResponse<Type: Decodable>: Decodable {

    public let isLastPage: Bool
    public let list: [Type]

    enum CodingKeys: String, CodingKey {

        case hasMore = "has_more"
        case list

    }

    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        isLastPage = !(try container.decodeIfPresent(Bool.self, forKey: .hasMore) ?? false)

        var dataContainer = try container.nestedUnkeyedContainer(forKey: .list)
        var data = [Type]()

        while !dataContainer.isAtEnd {

            guard let result = try? dataContainer.decode(Type.self) else {
                _ = try? dataContainer.decode(WildcardDecodable.self)
                continue
            }

            data.append(result)

        }

        list = data

    }

}

extension PaginatedResponse {

    private struct WildcardDecodable: Decodable {
    }

}
