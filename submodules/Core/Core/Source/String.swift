//
//  String.swift
//  Core
//
//  Created by Алексей Смирнов on 03.03.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

extension String {
  public var isNilOrEmpty: Bool {
    isEmpty
  }
}

extension Optional where Wrapped == String {
  public var isNilOrEmpty: Bool {
    if self == nil {
      return true
    } else {
      return self!.isEmpty // swiftlint:disable:this force_unwrapping
    }
  }
}

public func encodeText(_ string: String, _ key: Int) -> String {
  var result = ""
  for c in string.unicodeScalars {
    result.append(Character(UnicodeScalar(UInt32(Int(c.value) + key))!)) // swiftlint:disable:this force_unwrapping
  }
  return result
}
