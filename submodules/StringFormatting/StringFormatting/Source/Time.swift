//
//  Time.swift
//  StringFormatting
//
//  Created by Алексей Смирнов on 29.05.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

extension TimeInterval {
  public func toString() -> String? {
    let formatter = DateComponentsFormatter()

    formatter.maximumUnitCount = 1
    formatter.unitsStyle = .abbreviated
    formatter.zeroFormattingBehavior = .dropAll
    formatter.allowedUnits = [.hour, .minute]
    return formatter.string(from: self)
  }
}
