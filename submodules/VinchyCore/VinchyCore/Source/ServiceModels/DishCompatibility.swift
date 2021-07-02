//
//  DishCompatibility.swift
//  VinchyCore
//
//  Created by Aleksei Smirnov on 18.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import StringFormatting

public enum DishCompatibility: String, Decodable, CaseIterable {
  case meat = "Meat"
  case fish = "Fish"
  case poultry = "Poultry"
  case cheese = "Cheese"
  case shellfish = "Shellfish"
  case vegetarian = "Vegetarian"
  case spicy = "Spicy food"
  case mushrooms = "Mushrooms"
  case snacks = "Snacks"
  case pasta = "Pasta"
  case fruits = "Fruits"
  case desserts = "Desserts"
  case aperitif = "Aperitif"

  // MARK: Public

  public var imageName: String {
    switch self {
    case .meat:
      return "meat"

    case .fish:
      return "fish"

    case .poultry:
      return "chicken"

    case .desserts:
      return "cake"

    case .cheese:
      return "cheese"

    case .fruits:
      return "fruit"

    case .shellfish:
      return "shellfish"

    case .pasta:
      return "pasta"

    case .vegetarian:
      return "vegan"

    case .mushrooms:
      return "mushroom"

    case .spicy:
      return "spicy"

    case .aperitif:
      return "aperitif"

    case .snacks:
      return "snacks"
    }
  }

  public var localized: String {
    switch self {
    case .cheese:
      return StringFormatting.localized("cheese").firstLetterUppercased()

    case .fish:
      return StringFormatting.localized("fish").firstLetterUppercased()

    case .meat:
      return StringFormatting.localized("meat").firstLetterUppercased()

    case .poultry:
      return StringFormatting.localized("chicken").firstLetterUppercased()

    case .shellfish:
      return StringFormatting.localized("shellfish").firstLetterUppercased()

    case .vegetarian:
      return StringFormatting.localized("vegetarian").firstLetterUppercased()

    case .spicy:
      return StringFormatting.localized("spicy").firstLetterUppercased()

    case .mushrooms:
      return StringFormatting.localized("mushrooms").firstLetterUppercased()

    case .aperitif:
      return StringFormatting.localized("aperitif").firstLetterUppercased()

    case .snacks:
      return StringFormatting.localized("snacks").firstLetterUppercased()

    case .pasta:
      return StringFormatting.localized("pasta").firstLetterUppercased()

    case .fruits:
      return StringFormatting.localized("fruits").firstLetterUppercased()

    case .desserts:
      return StringFormatting.localized("dessert").firstLetterUppercased()
    }
  }
}
