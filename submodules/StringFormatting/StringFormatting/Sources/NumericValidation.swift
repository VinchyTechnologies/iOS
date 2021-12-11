//
//  NumericValidation.swift
//  StringFormatting
//
//  Created by Михаил Исаченко on 02.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

extension String {
  public var isNumeric: Bool {
    !isEmpty && allSatisfy { $0.isNumber }
  }
}
