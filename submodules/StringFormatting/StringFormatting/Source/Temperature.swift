//
//  Temperature.swift
//  StringFormatting
//
//  Created by Aleksei Smirnov on 04.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

public func localizedTemperature(_ value: Double?) -> String? {
  guard let value = value else { return nil }

  let formatter = MeasurementFormatter()
  formatter.locale = Locale.current
  let measurement = Measurement(value: value, unit: UnitTemperature.celsius)
  return formatter.string(from: measurement)
}
