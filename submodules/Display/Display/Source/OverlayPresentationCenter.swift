//
//  OverlayPresentationCenter.swift
//  Display
//
//  Created by Алексей Смирнов on 10.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

public typealias OverlayPresentableViewController = OverlayPresentable & UIViewController
public typealias OverlayPresentableView = OverlayPresentable & UIView

public protocol OverlayPresentableDelegate: AnyObject {
  func overlayPresentableDidDismiss(_ presentable: OverlayPresentable)
}

public protocol OverlayPresentable: AnyObject {
  var presentableDelegate: OverlayPresentableDelegate? { get set }
}

public protocol OverlayPresentationCenterProtocol: AnyObject {
  typealias PresentCompletion = () -> Void
  func presentViewController(_ viewController: OverlayPresentableViewController,
                             animated: Bool,
                             completion: PresentCompletion?)
  func presentView(_ view: OverlayPresentableView)
}

public extension OverlayPresentationCenterProtocol {
  func presentViewController(_ viewController: OverlayPresentableViewController, animated: Bool) {
    presentViewController(viewController, animated: animated, completion: nil)
  }
}

public final class OverlayPresentationCenter: OverlayPresentationCenterProtocol {
  
  private let application: UIApplication
  private var applicationKeyWindow: UIWindow?
  private lazy var presentationWindow = createPresentationWindow()
  private lazy var presentationViewController = createPresentationViewController()
  
  private var isAlreadyPresented: Bool {
    return presentationViewController.presentedViewController != nil || !presentationViewController.view.subviews.isEmpty
  }
  
  public init(application: UIApplication) {
    self.application = application
  }
  
  public func presentViewController(_ viewController: OverlayPresentableViewController,
                                    animated: Bool,
                                    completion: PresentCompletion?) {
    guard !isAlreadyPresented else { return }
    viewController.presentableDelegate = self
    applicationKeyWindow = application.windows.first(where: { $0.isKeyWindow })
    presentationWindow.makeKeyAndVisible()
    presentationViewController.present(viewController, animated: animated, completion: completion)
  }
  
  public func presentView(_ view: OverlayPresentableView) {
    guard !isAlreadyPresented else { return }
    view.presentableDelegate = self
    applicationKeyWindow = application.windows.first(where: { $0.isKeyWindow })
    presentationWindow.makeKeyAndVisible()
    
    view.translatesAutoresizingMaskIntoConstraints = false
    presentationViewController.view.addSubview(view)
    NSLayoutConstraint.activate([
      view.leadingAnchor.constraint(equalTo: presentationViewController.view.leadingAnchor),
      view.trailingAnchor.constraint(equalTo: presentationViewController.view.trailingAnchor),
      view.topAnchor.constraint(equalTo: presentationViewController.view.topAnchor),
      view.bottomAnchor.constraint(equalTo: presentationViewController.view.bottomAnchor)
    ])
  }
  
  private func createPresentationWindow() -> UIWindow {
    let window = UIWindow()
    window.backgroundColor = .clear
    return window
  }
  
  private func createPresentationViewController() -> UIViewController {
    let viewController = UIViewController()
    viewController.view.backgroundColor = .clear
    viewController.loadViewIfNeeded()
    presentationWindow.rootViewController = viewController
    return viewController
  }
}

extension OverlayPresentationCenter: OverlayPresentableDelegate {
  public func overlayPresentableDidDismiss(_ presentable: OverlayPresentable) {
    presentationWindow.isHidden = true
    applicationKeyWindow?.makeKey()
  }
}
