//
//  DeeplinkStep.swift
//  Smart
//
//  Created by Алексей Смирнов on 17.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Combine

open class DeeplinkStep<DeeplinkHandlerFlow, DeeplinkHandler> {
  
  private let flow: DeeplinkFlow<DeeplinkHandlerFlow>
  private let publisher: AnyPublisher<DeeplinkHandler, Never>
  
  init(
    flow: DeeplinkFlow<DeeplinkHandlerFlow>,
    publisher: AnyPublisher<DeeplinkHandler, Never>)
  {
    self.flow = flow
    self.publisher = publisher
  }
  
  func onStep<NextDeeplinkHandler>(
    _ onStep: @escaping (DeeplinkHandler) -> AnyPublisher<NextDeeplinkHandler, Never>)
    -> DeeplinkStep<DeeplinkHandlerFlow, NextDeeplinkHandler>
  {
    let nextStepPublisher =
      publisher
      .flatMap { deeplink in
        onStep(deeplink)
      }
      .eraseToAnyPublisher()
    return DeeplinkStep<DeeplinkHandlerFlow, NextDeeplinkHandler>(flow: flow, publisher: nextStepPublisher)
  }
  
  @discardableResult
  final func commit() -> DeeplinkFlow<DeeplinkHandlerFlow> {
    let cancelable = publisher.sink { _ in }
    flow.subscribtions.insert(cancelable)
    return flow
  }
}
