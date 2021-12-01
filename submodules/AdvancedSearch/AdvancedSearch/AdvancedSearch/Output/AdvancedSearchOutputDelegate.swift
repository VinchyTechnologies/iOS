//
//  AdvancedSearchOutputDelegate.swift
//  Smart
//
//  Created by Алексей Смирнов on 16.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Foundation

public protocol AdvancedSearchOutputDelegate: AnyObject {
  func didChoose(_ filters: [(String, String)])
}
