//
//  WinePlace.swift
//  Core
//
//  Created by Aleksei Smirnov on 23.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

public struct WinePlace: Decodable {
    public let lat: Double?
    public let lon: Double?
    public let country: String?
    public let region: String?
    public let province: String?
}
