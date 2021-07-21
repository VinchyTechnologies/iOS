//
//  LoadingView.swift
//  Smart
//
//  Created by Алексей Смирнов on 21.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import Epoxy
import UIKit

// MARK: - LoadingView

public final class LoadingView: UIView, EpoxyableView, Loadable {

  // MARK: Lifecycle

  override public init(frame: CGRect) {
    super.init(frame: frame)
    addLoader()
    startLoadingAnimation()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Public

  public private(set) var loadingIndicator = ActivityIndicatorView()

}

// MARK: DisplayRespondingView

extension LoadingView: DisplayRespondingView {
  public func didDisplay(_ isDisplayed: Bool) {
    if isDisplayed {
      startLoadingAnimation()
    }
  }
}
