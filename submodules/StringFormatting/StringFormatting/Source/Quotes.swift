//
//  Quotes.swift
//  StringFormatting
//
//  Created by Aleksei Smirnov on 04.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

extension String {
  public var quoted: String {
    guard
      let bQuote = Locale.current.quotationBeginDelimiter,
      let eQuote = Locale.current.quotationEndDelimiter
    else {
      return "\"" + self + "\""
    }

    return bQuote + self + eQuote
  }
}
