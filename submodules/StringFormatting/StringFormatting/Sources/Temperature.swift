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

public func localizedTemperature(_ value1: Double?, _ value2: Double?) -> String? {

  let formatter = MeasurementFormatter()
  formatter.locale = Locale.current
  formatter.unitStyle = .short

  if value1 == nil && value2 == nil {
    return nil

  } else if value1 != nil && value2 == nil {
    let measurement = Measurement(value: value1!, unit: UnitTemperature.celsius) // swiftlint:disable:this force_unwrapping
    return formatter.string(from: measurement)

  } else if value2 != nil && value1 == nil {
    let measurement = Measurement(value: value2!, unit: UnitTemperature.celsius) // swiftlint:disable:this force_unwrapping
    return formatter.string(from: measurement)

  } else if value1 != nil && value2 != nil {

    if value1 == value2 {
      let measurement = Measurement(value: value2!, unit: UnitTemperature.celsius) // swiftlint:disable:this force_unwrapping
      return formatter.string(from: measurement)
    }

    let minTemperature = String(Int(min(value1!, value2!))) // swiftlint:disable:this force_unwrapping
    let maxTemperature = String(Int(max(value1!, value2!))) // swiftlint:disable:this force_unwrapping

    return [minTemperature, maxTemperature].joined(separator: "-") + " " + formatter.string(from: UnitTemperature.celsius)
  }

  return nil
}
