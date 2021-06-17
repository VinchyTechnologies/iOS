//
//  FakeCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 22.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit

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

  private enum C {
    static let backgroundColor: UIColor = .option // UIColor.rgb(red: 241, green: 241, blue: 241) //.option
    static let duration: CFTimeInterval = 1.5
  }

  private var gradientMask = CAGradientLayer()
}
