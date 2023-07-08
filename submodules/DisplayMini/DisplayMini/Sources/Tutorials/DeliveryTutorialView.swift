//
//  DeliveryTutorialView.swift
//  DeliveryClub
//
//  Created by r.kuchukbaev on 21.01.2020.
//  Copyright © 2020 Delivery Club. All rights reserved.
//

import UIKit

// MARK: - DeliveryTutorialViewModel

public struct DeliveryTutorialViewModel {

  let title: String
  let content: String

  public init(title: String, content: String) {
    self.title = title
    self.content = content
  }
}

// MARK: - DeliveryTutorialView

public final class DeliveryTutorialView: UIView, TutorialContentViewProtocol {

  // MARK: Public

  public var anchorpoint = CGPoint(x: 1, y: 0) {
    didSet {
      setNeedsLayout()
    }
  }

  public static func size(viewModel: DeliveryTutorialViewModel, width: CGFloat) -> CGSize {
    let topSize = CGSize(width: Constants.imageSize.width + Constants.imageInsets.horizontal, height: Constants.imageSize.height + Constants.imageInsets.vertical)
    let titleSize = makeFitSize(
      availableWidth: width,
      font: Constants.titleLabelFont,
      text: viewModel.title,
      horizontalInsets: Constants.titleLabelInsets.horizontal,
      verticalInsets: Constants.titleLabelInsets.bottom)
    let bottomSize = makeFitSize(
      availableWidth: width,
      font: Constants.contentLabelFont,
      text: viewModel.content,
      horizontalInsets: Constants.contentLabelInsets.horizontal,
      verticalInsets: Constants.contentLabelInsets.bottom)
    return CGSize(width: max(topSize.width, titleSize.width, bottomSize.width), height: topSize.height + titleSize.height + bottomSize.height)
  }

  override public func layoutSubviews() {
    super.layoutSubviews()
    layer.anchorPoint = anchorpoint
  }

  override public func awakeFromNib() {
    super.awakeFromNib()
    backgroundColor = .option
    layer.cornerRadius = Constants.backgroundCornerRadius
  }

  public func reload(viewModel: DeliveryTutorialViewModel) {
    titleLabel.text = viewModel.title
    contentLabel.text = viewModel.content
    imageView.image = UIImage(systemName: "text.bubble.fill")?.withTintColor(.accent, renderingMode: .alwaysOriginal)
  }

  public func hide() {
    alpha = 0
  }

  public func animateAppear(completion: (() -> Void)?) {
    transform = Constants.smallSizeTransform
    UIView.animate(withDuration: Constants.animationDuration, animations: {
      self.transform = Constants.normalSizeTransform
      self.alpha = 1
    }, completion: { isFinished in
      if isFinished {
        completion?()
      }
    })
  }

  public func animateDisappear(completion: (() -> Void)?) {
    UIView.animate(withDuration: Constants.animationDuration, animations: {
      self.transform = Constants.smallSizeTransform
      self.alpha = 0
    }, completion: { isFinished in
      if isFinished {
        completion?()
      }
    })
  }

  // MARK: Private

  private enum Constants {
    static let backgroundCornerRadius: CGFloat = 16

    static let titleLabelFont = Font.bold(15)
    static let titleLabelColor = UIColor.dark
    static let contentLabelFont = Font.medium(15)
    static let contentLabelColor = UIColor.dark

    static let imageSize: CGSize = .init(width: 40, height: 40)
    static let imageInsets: UIEdgeInsets = .insets(top: 16, left: 16, bottom: 8)
    static let titleLabelInsets: UIEdgeInsets = .insets(top: 8, left: 16, bottom: 8, right: 16)
    static let contentLabelInsets: UIEdgeInsets = .insets(top: 8, left: 16, bottom: 16, right: 16)

    static let animationDuration = 0.4
    static let smallSizeTransform = CGAffineTransform(scaleX: 0.01, y: 0.01)
    static let normalSizeTransform = CGAffineTransform(scaleX: 1, y: 1)
  }

  @IBOutlet weak private var imageView: UIImageView!
  @IBOutlet weak private var imageViewWidthConstraint: NSLayoutConstraint!

  @IBOutlet weak private var titleLabel: UILabel! {
    didSet {
      titleLabel.font = Constants.titleLabelFont
      titleLabel.textColor = Constants.titleLabelColor
    }
  }
  @IBOutlet weak private var contentLabel: UILabel! {
    didSet {
      contentLabel.font = Constants.contentLabelFont
      contentLabel.textColor = Constants.contentLabelColor
    }
  }

  private static func makeFitSize(availableWidth: CGFloat, font: UIFont, text: String, horizontalInsets: CGFloat, verticalInsets: CGFloat) -> CGSize {
    let size = text.size(for: font)
    var height = size.height
    var width = size.width + horizontalInsets
    if width > availableWidth {
      height = text.height(forWidth: availableWidth - horizontalInsets, font: font)
      width = availableWidth
    }
    return CGSize(width: width, height: height + verticalInsets)
  }
}

extension UIEdgeInsets {

  public var vertical: CGFloat { top + bottom }
  public var horizontal: CGFloat { left + right }

  public static func insets(
    top: CGFloat = .zero,
    left: CGFloat = .zero,
    bottom: CGFloat = .zero,
    right: CGFloat = .zero)
    -> UIEdgeInsets
  {
    UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
  }

  public static func insets(horizontal value: CGFloat) -> UIEdgeInsets {
    UIEdgeInsets(
      top: .zero,
      left: value,
      bottom: .zero,
      right: value)
  }

  public static func inset(_ value: CGFloat) -> UIEdgeInsets {
    UIEdgeInsets(top: value, left: value, bottom: value, right: value)
  }

  public static func + (lhs: Self, rhs: Self) -> Self {
    .init(
      top: lhs.top + rhs.top,
      left: lhs.left + rhs.left,
      bottom: lhs.bottom + rhs.bottom,
      right: lhs.right + rhs.right)
  }
}
