//
//  GradientView.swift
//  Display
//
//  Created by Aleksei Smirnov on 28.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

public final class GradientView: UIView {

  public enum C {
    public static let defaultFromColor = UIColor.clear
    public static let defaultToColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    public static let defaultStartPoint = CGPoint(x: 0.5, y: 0)
    public static let defaultEndPoint = CGPoint(x: 0.5, y: 1)
  }

  private var gradient: CAGradientLayer {
    didSet {
      gradient.actions = ["bounds": NSNull(), "position": NSNull()]
    }
  }

  var fromColor: UIColor = C.defaultFromColor
  var toColor: UIColor = C.defaultToColor

  var startPoint: CGPoint = C.defaultStartPoint
  var endPoint: CGPoint = C.defaultEndPoint

  // MARK: - Initializers

  public required init(
    frame: CGRect,
    fromColor: UIColor = C.defaultFromColor,
    toColor: UIColor = C.defaultToColor,
    startPoint: CGPoint = C.defaultStartPoint,
    endPoint: CGPoint = C.defaultEndPoint)
  {

    self.fromColor = fromColor
    self.toColor = toColor

    self.startPoint = startPoint
    self.endPoint = endPoint

    gradient = GradientView.createGradientShadow(
      from: self.fromColor,
      to: self.toColor,
      startPoint: self.startPoint,
      endPoint: self.endPoint)

    super.init(frame: frame)

    customizeAppearance()
    layer.addSublayer(gradient)
  }

  required init?(coder aDecoder: NSCoder) { fatalError() }

  public override func layoutSubviews() {
    super.layoutSubviews()
    gradient.frame = bounds
  }

  func setGradient(from fromColor: UIColor, to toColor: UIColor, isByAxisX: Bool = false) {

    let color1 = fromColor.cgColor
    let color2 = toColor.cgColor
    gradient.colors = [color1, color2]

    if isByAxisX {
      gradient.startPoint = CGPoint.zero
      gradient.endPoint = CGPoint(x: 1, y: 0)
    } else {
      gradient.startPoint = CGPoint.zero
      gradient.endPoint = CGPoint(x: 0, y: 1)
    }
  }

  static func createGradientShadow(
    from fromColor: UIColor,
    to toColor: UIColor,
    startPoint: CGPoint,
    endPoint: CGPoint)
    -> CAGradientLayer
  {

    let gradientLayer = CAGradientLayer()

    let color1 = fromColor.cgColor
    let color2 = toColor.cgColor
    gradientLayer.colors = [color1, color2]
    gradientLayer.startPoint = startPoint
    gradientLayer.endPoint = endPoint

    gradientLayer.locations = [0.0, 0.8]

    return gradientLayer
  }

  private func customizeAppearance() {
    backgroundColor = UIColor.clear
    isOpaque = false
    clipsToBounds = false
  }
}
