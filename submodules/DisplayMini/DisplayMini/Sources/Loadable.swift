//
//  Loadable.swift
//  Display
//
//  Created by Aleksei Smirnov on 01.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

// MARK: - Loadable

public protocol Loadable: AnyObject {
  var loadingIndicator: ActivityIndicatorView { get }

  func addLoader()
  func startLoadingAnimation()
  func stopLoadingAnimation()
}

extension Loadable where Self: UIViewController {
  public func addLoader() {
    loadViewIfNeeded()
    view.addSubview(loadingIndicator)
    loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      loadingIndicator.widthAnchor.constraint(equalToConstant: 36),
      loadingIndicator.heightAnchor.constraint(equalToConstant: 36),
      loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    ])
  }

  public func startLoadingAnimation() {
    loadingIndicator.isAnimating = true
  }

  public func stopLoadingAnimation() {
    loadingIndicator.isAnimating = false
  }
}

extension Loadable where Self: UIView {
  public func addLoader() {
    addSubview(loadingIndicator)
    loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      loadingIndicator.widthAnchor.constraint(equalToConstant: 36),
      loadingIndicator.heightAnchor.constraint(equalToConstant: 36),
      loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
      loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
    ])
  }

  public func startLoadingAnimation() {
    loadingIndicator.isAnimating = true
  }

  public func stopLoadingAnimation() {
    loadingIndicator.isAnimating = false
  }
}
