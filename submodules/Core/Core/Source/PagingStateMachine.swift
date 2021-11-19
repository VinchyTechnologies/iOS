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
  case loading(offset: Int, usingRefreshControl: Bool = false)
  case error(Error)
}

// MARK: - PagingEvent

public enum PagingEvent<Data> {
  case load(offset: Int, usingRefreshControl: Bool = false)
  case success(Data)
  case fail(Error)
}

// MARK: - PagingStateMachine

public final class PagingStateMachine<Data>: StateMachine<PagingState<Data>, PagingEvent<Data>> {

  // MARK: Lifecycle

  public init() {
    super.init(state: .initial) { currentState, event in
      switch (currentState, event) {
      case (.initial, .load(let offset, let usingRefreshControl)):
        return .loading(offset: offset, usingRefreshControl: usingRefreshControl)

      case (.loaded, .load(let offset, let usingRefreshControl)):
        return .loading(offset: offset, usingRefreshControl: usingRefreshControl)

      case (.error, .load(let offset, let usingRefreshControl)):
        return .loading(offset: offset, usingRefreshControl: usingRefreshControl)

      case (.loading, .success(let data)):
        return .loaded(data)

      case (.loading, .fail(let error)):
        return .error(error)

      case (.loading, .load(let offset, let usingRefreshControl)):
        return .loading(offset: offset, usingRefreshControl: usingRefreshControl)

      case (.error(_), .success(let data)):
        return .loaded(data)

      case (.error(_), .fail(let error)):
        return .error(error)

      case (.loaded(_), .success(let data)):
        return .loaded(data)

      case (.loaded(_), .fail(let error)):
        return .error(error)

      case (.initial, .success(let data)):
        return .loaded(data)

      case (.initial, .fail(let error)):
        return .error(error)
      }
    }
  }

  // MARK: Public

  public func load(offset: Int, usingRefreshControl: Bool = false) {
    process(event: .load(offset: offset, usingRefreshControl: usingRefreshControl))
  }

  public func invokeSuccess(with data: Data) {
    process(event: .success(data))
  }

  public func fail(with error: Error) {
    process(event: .fail(error))
  }
}
