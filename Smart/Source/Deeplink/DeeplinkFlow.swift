//
//  DeeplinkFlow.swift
//  Smart
//
//  Created by Алексей Смирнов on 17.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Combine

open class DeeplinkFlow<DeeplinkHandler> {
  
  private let subject = PassthroughSubject<DeeplinkHandler, Never>()
  var subscribtions = Set<AnyCancellable>()
  
  final func onStep<NextDeeplinkHandler>(
    _ onStep: @escaping (DeeplinkHandler) -> AnyPublisher<NextDeeplinkHandler, Never>)
    -> DeeplinkStep<DeeplinkHandler, NextDeeplinkHandler>
  {
    DeeplinkStep(flow: self, publisher: subject.eraseToAnyPublisher())
      .onStep { deeplink in
        onStep(deeplink)
      }
  }
  
  func subcscribe(_ deeplinkHandler: DeeplinkHandler) -> Set<AnyCancellable> {
    subject.send(deeplinkHandler)
    return subscribtions
  }
}
