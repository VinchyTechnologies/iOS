//
//  PagingStateMachine.swift
//  Core
//
//  Created by Алексей Смирнов on 09.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

public enum PagingState<Data> {
  case initial
  case loaded(Data)
  case loading(offset: Int)
  case error(Error)
}

public enum PagingEvent<Data> {
  case load(offset: Int)
  case success(Data)
  case fail(Error)
}

public final class PagingStateMachine<Data>: StateMachine<PagingState<Data>, PagingEvent<Data>> {
  
  public init() {
    super.init(state: .initial) { currentState, event in
      switch (currentState, event) {
      case let (.initial, .load(offset)):
        return .loading(offset: offset)
        
      case let (.loaded, .load(offset)):
        return .loading(offset: offset)
        
      case let (.error, .load(offset)):
        return .loading(offset: offset)
        
      case let (.loading, .success(data)):
        return .loaded(data)
        
      case let (.loading, .fail(error)):
        return .error(error)
        
      default:
        return nil
      }
    }
  }
  
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
