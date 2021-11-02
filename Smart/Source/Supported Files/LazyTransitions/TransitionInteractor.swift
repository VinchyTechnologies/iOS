//
//  TransitionInteractor.swift
//  LazyTransitions
//
//  Created by Serghei Catraniuc on 1/18/16.
//  Copyright © 2016 BeardWare. All rights reserved.
//

import UIKit

public class TransitionInteractor: UIPercentDrivenInteractiveTransition {

  public static func `default`() -> TransitionInteractor {
    let transitionInteractor = TransitionInteractor()
    transitionInteractor.completionCurve = .easeInOut
    return transitionInteractor
  }

  public func setCompletionSpeedForFinish() {
    completionSpeed = 1.0
  }

  public func setCompletionSpeedForCancel() {
    completionSpeed = 1.0
  }
}
