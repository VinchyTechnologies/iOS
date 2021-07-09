//
//  Localized.swift
//  StringFormatting
//
//  Created by Aleksei Smirnov on 19.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

// MARK: - LocalizedSource

public enum LocalizedSource: String {
  case common = "Localizable"
  case countries = "Countries"
}

public func localized(
  _ string: String,
  bundle: Bundle = Bundle.main,
  from source: LocalizedSource = .common)
  -> String
{
  NSLocalizedString(string, tableName: source.rawValue, bundle: bundle, comment: "")
}


public func localizedPlural(
  _ string: String,
  count: UInt,
  bundle: Bundle = Bundle.main)
  -> String
{
  let formatString: String = NSLocalizedString(
    string,
    tableName: "PluralLocalizable",
    bundle: bundle,
    comment: "")
  let resultString = String.localizedStringWithFormat(formatString, count)
  return resultString
}
