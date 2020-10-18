//
//  Winery.swift
//  VinchyCore
//
//  Created by Aleksei Smirnov on 04.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

public final class Winery: Decodable {

    public let id: Int64
    public let title: String
    public let countryCode: String
    public let region: String

    private enum CodingKeys: String, CodingKey {
        case id = "winery_id"
        case title
        case countryCode = "country_code"
        case region
    }
}
