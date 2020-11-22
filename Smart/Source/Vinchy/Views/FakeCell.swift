//
//  FakeCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 22.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

final class FakeCell: UICollectionViewCell, ShimmeringView, Reusable {

  private enum C {
    static let backgroundColor: UIColor = .option//UIColor.rgb(red: 241, green: 241, blue: 241) //.option
    static let duration: CFTimeInterval = 1.5
  }

  public var bgView = UIView()

  private var gradientMask: CAGradientLayer = CAGradientLayer()

  public var shouldAnimateBgView = true

  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(bgView)
    bgView.backgroundColor = C.backgroundColor
  }

  required init?(coder: NSCoder) { fatalError() }

  public override func layoutSubviews() {
    super.layoutSubviews()

    bgView.frame = bounds

    guard shouldAnimateBgView else { return }
    self.gradientMask.removeFromSuperlayer()
    self.gradientMask.removeAllAnimations()
    self.gradientMask = self.getShimmering(beginTime: CACurrentMediaTime(), duration: C.duration)
    self.bgView.layer.insertSublayer(self.gradientMask, at: .zero)
  }

  func generateShimmeringLayerFrame(forSuperframe superframe: CGRect) -> CGRect {
    bgView.bounds
  }

}
