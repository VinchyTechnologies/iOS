//
//  FakeCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 22.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import DisplayMini
import EpoxyCore
import UIKit

// MARK: - C

fileprivate enum C {
  static let backgroundColor: UIColor = .option
  static let duration: CFTimeInterval = 1.5
}

// MARK: - FakeCell

final class FakeCell: UICollectionViewCell, ShimmeringView, Reusable {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(bgView)
    bgView.backgroundColor = C.backgroundColor
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Public

  public var bgView = UIView()

  public var shouldAnimateBgView = true

  override public func layoutSubviews() {
    super.layoutSubviews()

    bgView.frame = bounds

    guard shouldAnimateBgView else { return }
    gradientMask.removeFromSuperlayer()
    gradientMask.removeAllAnimations()
    gradientMask = getShimmering(beginTime: CACurrentMediaTime(), duration: C.duration)
    bgView.layer.insertSublayer(gradientMask, at: .zero)
  }

  // MARK: Internal

  func generateShimmeringLayerFrame(forSuperframe _: CGRect) -> CGRect {
    bgView.bounds
  }

  // MARK: Private

  private var gradientMask = CAGradientLayer()
}

// MARK: - FakeView

final class FakeView: UIView, EpoxyableView, ShimmeringView {

  // MARK: Lifecycle

  init(style: Style) {
    super.init(frame: .zero)
    addSubview(bgView)
    bgView.backgroundColor = C.backgroundColor
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Public

  public var bgView = UIView()

  public var shouldAnimateBgView = true

  override public func layoutSubviews() {
    super.layoutSubviews()

    bgView.frame = bounds

    guard shouldAnimateBgView else { return }
    gradientMask.removeFromSuperlayer()
    gradientMask.removeAllAnimations()
    gradientMask = getShimmering(beginTime: CACurrentMediaTime(), duration: C.duration)
    bgView.layer.insertSublayer(gradientMask, at: .zero)
    bgView.layer.cornerRadius = 12
    bgView.clipsToBounds = true
    gradientMask.cornerRadius = 12
    clipsToBounds = true
    layer.cornerRadius = 12
  }

  // MARK: Internal

  struct Style: Hashable {

  }
  struct Content: Equatable {
  }

  func generateShimmeringLayerFrame(forSuperframe _: CGRect) -> CGRect {
    bgView.bounds
  }

  func setContent(_ content: Content, animated: Bool) {
  }

  // MARK: Private

  private var gradientMask = CAGradientLayer()

}
