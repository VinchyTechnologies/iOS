//
//  Emoji.swift
//  StringFormatting
//
//  Created by Алексей Смирнов on 14.01.2022.
//  Copyright © 2022 Aleksei Smirnov. All rights reserved.
//

public func emojiFlagForISOCountryCode(_ countryCode: String) -> String {
  if countryCode.count != 2 {
    return ""
  }

  if countryCode == "XG" {
    return "🛰️"
  } else if countryCode == "XV" {
    return "🌍"
  }

  if ["YL"].contains(countryCode) {
    return ""
  }

  let base: UInt32 = 127397
  var s = ""
  for v in countryCode.unicodeScalars {
    s.unicodeScalars.append(UnicodeScalar(base + v.value)!) // swiftlint:disable:this force_unwrapping
  }
  return String(s)
}
