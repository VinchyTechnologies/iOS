//
//  URL.swift
//  Core
//
//  Created by Aleksei Smirnov on 04.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

extension String {
  public var toURL: URL? {
    if self == "" {
      return nil
    }

    return URL(string: self)
  }
}

extension Optional where Wrapped == String {
  public var toURL: URL? {
    if self == nil || self == "" {
      return nil
    }

    return URL(string: self!) // swiftlint:disable:this force_unwrapping
  }
}
