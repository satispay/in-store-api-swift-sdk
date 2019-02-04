//
//  PaginatedDataResponse.swift
//  SatispayInStore
//
//  Created by Pierluigi D'Andrea on 16/01/2019.
//  Copyright © 2019 Pierluigi D'Andrea. All rights reserved.
//

import Foundation

public struct PaginatedDataResponse<Type: Decodable>: Decodable {

    public let isLastPage: Bool
    public let data: [Type]

    enum CodingKeys: String, CodingKey {

        case hasMore = "has_more"
        case data

    }

    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        isLastPage = !(try container.decodeIfPresent(Bool.self, forKey: .hasMore) ?? false)

        var dataContainer = try container.nestedUnkeyedContainer(forKey: .data)
        var data = [Type]()

        while !dataContainer.isAtEnd {

            guard let result = try? dataContainer.decode(Type.self) else {
                _ = try? dataContainer.decode(WildcardDecodable.self)
                continue
            }

            data.append(result)

        }

        self.data = data

    }

}

extension PaginatedDataResponse {

    private struct WildcardDecodable: Decodable {
    }

}

extension PaginatedDataResponse: Equatable where Type: Equatable {
}
