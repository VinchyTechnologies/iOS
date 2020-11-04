//
//  CountryCode.swift
//  Core
//
//  Created by Aleksei Smirnov on 16.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

public struct Country: Decodable {
  public let code: String
  public let country: String
}

public func loadCountryCodes() -> [Country] {

  guard let filePath = Bundle.main.path(forResource: "country_codes", ofType: "json") else {
    return []
  }

  guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
    return []
  }

  return try! JSONDecoder().decode([Country].self, from: data) // swiftlint:disable:this force_try
}
