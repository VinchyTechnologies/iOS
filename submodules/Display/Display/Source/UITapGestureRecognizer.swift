//
//  UITapGestureRecognizer.swift
//  Display
//
//  Created by Алексей Смирнов on 13.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

extension UITapGestureRecognizer {
  public func didTapAttributedTextInLabel(
    label: UILabel,
    inRange targetRange: NSRange)
    -> Bool
  {
    guard let attributedText = label.attributedText else {
      return false
    }

    let mutableStr = NSMutableAttributedString(attributedString: attributedText)
    mutableStr.addAttributes(
      [NSAttributedString.Key.font: label.font ?? .boldSystemFont(ofSize: 18)],
      range: NSRange(location: 0, length: attributedText.length))

    // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
    let layoutManager = NSLayoutManager()
    let textContainer = NSTextContainer(size: .zero)
    let textStorage = NSTextStorage(attributedString: mutableStr)

    // Configure layoutManager and textStorage
    layoutManager.addTextContainer(textContainer)
    textStorage.addLayoutManager(layoutManager)

    // Configure textContainer
    textContainer.lineFragmentPadding = 0.0
    textContainer.lineBreakMode = label.lineBreakMode
    textContainer.maximumNumberOfLines = label.numberOfLines
    let labelSize = label.bounds.size
    textContainer.size = labelSize

    // Find the tapped character location and compare it to the specified range
    let locationOfTouchInLabel = location(in: label)
    let textBoundingBox = layoutManager.usedRect(for: textContainer)
    let x = (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x
    let y = (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y
    let textContainerOffset = CGPoint(x: x, y: y)
    let locationOfTouchInTextContainer = CGPoint(
      x: locationOfTouchInLabel.x - textContainerOffset.x,
      y: locationOfTouchInLabel.y - textContainerOffset.y)
    let indexOfCharacter = layoutManager.characterIndex(
      for: locationOfTouchInTextContainer,
      in: textContainer,
      fractionOfDistanceBetweenInsertionPoints: nil)
    return NSLocationInRange(indexOfCharacter, targetRange)
  }
}
