//
//  Localized.swift
//  StringFormatting
//
//  Created by Aleksei Smirnov on 19.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

public enum LocalizedSource: String {
  case common = "Localizable"
  case countries = "Countries"
}

public func localized(
  _ string: String,
  from source: LocalizedSource = .common)
  -> String
{
  NSLocalizedString(string, tableName: source.rawValue, bundle: Bundle.main, comment: "")
}
