//
//  ShowcaseRoutable.swift
//  VinchyUI
//
//  Created by Алексей Смирнов on 01.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

// MARK: - ShowcaseInput

public struct ShowcaseInput {
  public let title: String?
  public let mode: ShowcaseMode
  public init(title: String?, mode: ShowcaseMode) {
    self.title = title
    self.mode = mode
  }
}

// MARK: - ShowcaseMode

public enum ShowcaseMode {
  case advancedSearch(params: [(String, String)])
  case remote(collectionID: Int)
  case questions(optionsIds: [Int], affilatedId: Int)
}

// MARK: - ShowcaseRoutable

public protocol ShowcaseRoutable: AnyObject {
  func pushToShowcaseViewController(input: ShowcaseInput)
}
