//
//  Keyboard.swift
//  Display
//
//  Created by Aleksei Smirnov on 17.07.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

public struct AnimationParameters {

  let duration: TimeInterval
  let padding: CGFloat
  let options: UIView.AnimationOptions
}

public final class KeyboardHelper {

  public typealias AnimateBlock = (_ padding: CGFloat) -> Void
  public typealias AnimationCompletionBlock = (_ padding: CGFloat) -> Void
  public typealias AnimationParametersBlock = (AnimationParameters) -> Void

  private var keyboardUpdate: KeyboardUpdate? {
    didSet {
      if let keyboardUpdate = keyboardUpdate {
        update(keyboardUpdate: keyboardUpdate)
      }
    }
  }

  private var animateBlock: AnimateBlock?

  private var animated = true

  private var animationCompletionBlock: AnimationCompletionBlock?

  private var animationParametersBlock: AnimationParametersBlock?

  private struct KeyboardUpdate {

    let duration: TimeInterval
    let options: UIView.AnimationOptions
    let padding: CGFloat
    let show: Bool

    init?(notification: Notification) {

      guard let userInfo = notification.userInfo else {
        return nil
      }

      guard
        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
        let keyboardEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
        let animationCurve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue
      else {
        return nil
      }

      let padding = KeyboardUpdate.padding(forFrame: keyboardEndFrame)
      let options = UIView.AnimationOptions(rawValue: (animationCurve as UInt) << 16)

      self.duration = duration
      self.options = options
      self.padding = padding
      self.show = notification.name != UIResponder.keyboardWillHideNotification
    }

    private static func padding(forFrame frame: CGRect) -> CGFloat {

      let endYPosition = frame.origin.y
      let keyboardHeight = frame.height
      let windowHeight = UIApplication.shared.asKeyWindow?.frame.height ?? 0
      let padding = endYPosition >= windowHeight ? 0.0 : keyboardHeight

      return padding
    }
  }

  public init() { }

  private func keyboardFrameObservable() {

    let notificationCenter = NotificationCenter.default

    notificationCenter.addObserver(
      self,
      selector: #selector(updateKeyboard(notification:)),
      name: UIResponder.keyboardWillHideNotification,
      object: nil)

    notificationCenter.addObserver(
      self,
      selector: #selector(updateKeyboard(notification:)),
      name: UIResponder.keyboardWillShowNotification,
      object: nil)
  }

  @objc
  func updateKeyboard(notification: Notification) {
    self.keyboardUpdate = KeyboardUpdate(notification: notification)
  }

  private func update(keyboardUpdate: KeyboardUpdate) {

    guard animated && keyboardUpdate.duration > 0.0 else {
      animateBlock?(keyboardUpdate.padding)
      animationParametersBlock?(AnimationParameters(
                                  duration: keyboardUpdate.duration,
                                  padding: keyboardUpdate.padding,
                                  options: keyboardUpdate.options))
      return
    }

    UIView.animate(
      withDuration: keyboardUpdate.duration,
      delay: 0.0,
      options: keyboardUpdate.options,
      animations: { [weak self] in
        self?.animateBlock?(keyboardUpdate.padding)
      },
      completion: { [weak self] isFinished in
        if isFinished {
          self?.animationCompletionBlock?(keyboardUpdate.padding)
        }
      })
  }

  public func bindBottomToKeyboardFrame(
    animated: Bool = true,
    animate: AnimateBlock? = nil,
    completion: AnimationCompletionBlock? = nil,
    animationParametersBlock: AnimationParametersBlock? = nil) {

    self.animated = animated
    self.animateBlock = animate
    self.animationCompletionBlock = completion
    self.animationParametersBlock = animationParametersBlock

    keyboardFrameObservable()
  }
}
