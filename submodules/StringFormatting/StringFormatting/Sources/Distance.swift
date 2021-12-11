//
//  Distance.swift
//  StringFormatting
//
//  Created by Алексей Смирнов on 29.05.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CoreLocation

extension CLLocationDistance {
  public func toDistance() -> String? {
    let distanceFormatter = MeasurementFormatter()
    distanceFormatter.unitStyle = .short
    let numberFormatter = NumberFormatter()
    numberFormatter.maximumFractionDigits = 2
    distanceFormatter.numberFormatter = numberFormatter
    let measurement = Measurement(value: self, unit: UnitLength.meters)
    return distanceFormatter.string(from: measurement)
  }
}
