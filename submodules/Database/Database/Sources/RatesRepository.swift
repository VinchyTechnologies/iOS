//
//  RatesRepository.swift
//  Database
//
//  Created by Алексей Смирнов on 02.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

public var ratesRepository = RatesRepository.shared

// MARK: - RatesRepository

public final class RatesRepository {

  // MARK: Lifecycle

  public init() {

  }

  // MARK: Public

  public enum State: String {
    case normal
    case needsReload
  }

  public static let shared = RatesRepository()

  public var state: State = .normal {
    didSet {
      print(state.rawValue)
    }
  }
}
