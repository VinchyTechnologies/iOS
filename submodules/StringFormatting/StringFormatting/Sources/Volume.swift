//
//  Volume.swift
//  StringFormatting
//
//  Created by Алексей Смирнов on 08.04.2022.
//  Copyright © 2022 Aleksei Smirnov. All rights reserved.
//

fileprivate let formatter = MeasurementFormatter()

extension Float {
  public var volume: String {
    formatter.locale = Locale.current
    formatter.unitStyle = .short
    var last = ""
    if let firstLetter = formatter.string(from: UnitVolume.liters).first {
      last += " " + String(firstLetter).firstLetterUppercased()
    }
    return String(self) + last
  }
}
