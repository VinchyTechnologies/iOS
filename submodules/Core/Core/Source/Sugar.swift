//
//  Sugar.swift
//  Core
//
//  Created by Aleksei Smirnov on 23.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

public enum Sugar: String, Decodable {
    case dry
    case semiDry = "semi-dry"
    case semiSweet = "semi-sweet"
    case sweet
    case none
}
