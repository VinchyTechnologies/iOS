//
//  DateFormatter.swift
//  StringFormatting
//
//  Created by Алексей Смирнов on 22.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

fileprivate let dateFormatter: DateFormatter = {
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
  dateFormatter.timeZone = TimeZone(identifier: "UTC")
  return dateFormatter
}()

fileprivate let readableDateFormatter: DateFormatter = {
  let dateFormatter = DateFormatter()
  dateFormatter.dateStyle = .short
  return dateFormatter
}()

public extension Optional where Wrapped == String {
  func toDate() -> String? {
    guard let self = self else { return nil }
    guard let date = dateFormatter.date(from: self) else {
      return nil
    }
    return readableDateFormatter.string(from: date)
  }
}

public extension String {
  func toDate() -> String? {
    guard let date = dateFormatter.date(from: self) else {
      return nil
    }
    return readableDateFormatter.string(from: date)
  }
}
