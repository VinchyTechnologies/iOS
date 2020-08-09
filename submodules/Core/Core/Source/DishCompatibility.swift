//
//  DishCompatibility.swift
//  Core
//
//  Created by Aleksei Smirnov on 23.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import RealmSwift

public enum DishCompatibility: String, Decodable, RealmCollectionValue {
    case meat, fish, seafood, wildfowl, chicken, dessert, bakery, cheese, fruits

    public var imageName: String {
        switch self {
        case .meat:
            return "meat"
        case .fish:
            return "fish"
        case .seafood:
            return "shrimp"
        case .wildfowl:
            return "rabbit"
        case .chicken:
            return "chicken"
        case .dessert:
            return "cake"
        case .bakery:
            return "bread"
        case .cheese:
            return "cheese"
        case .fruits:
            return "fruit"
        }
    }
}
