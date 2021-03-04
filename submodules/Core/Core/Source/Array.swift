//
//  Array.swift
//  Core
//
//  Created by Aleksei Smirnov on 28.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

public extension Array {
  func grouped<T: Hashable>(map: ((Element) -> (T))) -> [[Element]] {
    let dict = Dictionary(grouping: self) { map($0) }
    return dict.values.map { Array<Element>($0) }
  }
}

public extension Array where Element == String? {

  func toURLs() -> [URL]? {

    var urls: [URL?] = []

    self.forEach { string in
      if let string = string, string.isEmpty == false {
        urls.append(URL(string: string))
      }
    }

    var urlArray: [URL] = []
    urlArray = urls.compactMap({ $0 })

    if urlArray.isEmpty {
      return nil
    }

    return urlArray
  }
}
