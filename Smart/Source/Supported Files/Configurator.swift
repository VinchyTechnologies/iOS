//
//  Configurator.swift
//  Smart
//
//  Created by Михаил Исаченко on 17.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

public protocol Configurator {
  associatedtype Input
  associatedtype View
  func configure(view: View, with input: Input)
}
