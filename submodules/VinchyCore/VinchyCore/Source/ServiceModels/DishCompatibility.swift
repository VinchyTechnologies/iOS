//
//  DishCompatibility.swift
//  VinchyCore
//
//  Created by Aleksei Smirnov on 18.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

public enum DishCompatibility: String, Decodable {
    
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
