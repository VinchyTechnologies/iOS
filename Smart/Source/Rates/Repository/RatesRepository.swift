//
//  RatesRepository.swift
//  Smart
//
//  Created by Алексей Смирнов on 19.11.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

var ratesRepository = RatesRepository.shared

// MARK: - RatesRepository

final class RatesRepository {

  // MARK: Lifecycle

  init() {

  }

  // MARK: Internal

  enum State: String {
    case normal
    case needsReload
  }

  static let shared = RatesRepository()

  var state: State = .normal {
    didSet {
      print(state.rawValue)
    }
  }
}
