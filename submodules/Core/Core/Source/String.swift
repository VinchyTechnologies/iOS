//
//  String.swift
//  Core
//
//  Created by Алексей Смирнов on 03.03.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

public extension String {
  
  var isNilOrEmpty: Bool {
    return self.isEmpty
  }
}

extension Optional where Wrapped == String {
  
  var isNilOrEmpty: Bool {
    if self == nil {
      return true
    } else {
      return self!.isEmpty // swiftlint:disable:this force_unwrapping
    }
  }
}
