//
//  StateMachine.swift
//  Core
//
//  Created by Алексей Смирнов on 09.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

open class StateMachine<S, E> {
  
  public typealias State = S
  public typealias Event = E
  public typealias TransitionClosure = (_ oldState: State, Event) -> State?
  public typealias ObserveClosure = (_ oldState: State, _ newState: State, _ event: Event) -> Void
  public typealias TransitionErrorHandler = (_ oldState: State, Event) -> Void
  
  public private(set) var currentState: S
  private let lock: LockProtocol
  private var observerClosure: ObserveClosure?
  private var transitionClosure: TransitionClosure?
  private var errorHandler: TransitionErrorHandler?
  
  public init(
    state: State,
    lock: LockProtocol = NSRecursiveLock(),
    transitions: @escaping TransitionClosure)
  {
    self.currentState = state
    self.lock = lock
    self.transitionClosure = transitions
  }
  
  public final func process(event: Event) {
    lock.synchronized {
      guard
        let newState = transitionClosure?(currentState, event)
      else {
        errorHandler?(currentState, event)
        return
      }
      
      let oldState = currentState
      currentState = newState
      observerClosure?(oldState, newState, event)
    }
  }
  
  public final func observe(_ observerClosure: @escaping ObserveClosure) {
    lock.synchronized {
      self.observerClosure = observerClosure
    }
  }
  
  public final func handleStateTransitionError(_ errorHandler: @escaping TransitionErrorHandler) {
    lock.synchronized {
      self.errorHandler = errorHandler
    }
  }
}
