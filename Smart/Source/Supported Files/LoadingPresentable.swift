//
//  LoadPresentable.swift
//  Smart
//
//  Created by Михаил Исаченко on 02.09.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import DisplayMini

// MARK: - LoadingPresentable

public protocol LoadingPresentable: AnyObject {
  var viewController: Loadable? { get }
  func startLoading()
  func stopLoading()
}

extension LoadingPresentable {

  func startLoading() {
    viewController?.startLoadingAnimation()
    viewController?.addLoader()
  }

  func stopLoading() {
    viewController?.startLoadingAnimation()
    viewController?.addLoader()
  }
}
