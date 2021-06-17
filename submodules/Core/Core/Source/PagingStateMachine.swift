//
//  PagingStateMachine.swift
//  Core
//
//  Created by Алексей Смирнов on 09.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

// MARK: - PagingState

public enum PagingState<Data> {
  case initial
  case loaded(Data)
  case loading(offset: Int)
  case error(Error)
}

// MARK: - PagingEvent

public enum PagingEvent<Data> {
  case load(offset: Int)
  case success(Data)
  case fail(Error)
}

// MARK: - PagingStateMachine

public final class PagingStateMachine<Data>: StateMachine<PagingState<Data>, PagingEvent<Data>> {

  // MARK: Lifecycle

  public init() {
    super.init(state: .initial) { currentState, event in
      switch (currentState, event) {
      case (.initial, .load(let offset)):
        return .loading(offset: offset)

      case (.loaded, .load(let offset)):
        return .loading(offset: offset)

      case (.error, .load(let offset)):
        return .loading(offset: offset)

      case (.loading, .success(let data)):
        return .loaded(data)

      case (.loading, .fail(let error)):
        return .error(error)

      default:
        return nil
      }
    }
  }

  // MARK: Public

  public func load(offset: Int) {
    process(event: .load(offset: offset))
  }

  public func invokeSuccess(with data: Data) {
    process(event: .success(data))
  }

  public func fail(with error: Error) {
    process(event: .fail(error))
  }
}
