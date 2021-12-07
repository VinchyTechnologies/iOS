//
//  Gradient.swift
//  Display
//
//  Created by Aleksei Smirnov on 15.10.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

//import UIKit
//
//public typealias GradientPoints = (startPoint: CGPoint, endPoint: CGPoint)
//
//// MARK: - GradientOrientation
//
//public enum GradientOrientation {
//  case topRightBottomLeft
//  case topLeftBottomRight
//  case horizontal
//  case vertical
//
//  // MARK: Internal
//
//  var startPoint: CGPoint {
//    points.startPoint
//  }
//
//  var endPoint: CGPoint {
//    points.endPoint
//  }
//
//  var points: GradientPoints {
//    switch self {
//    case .topRightBottomLeft:
//      return (CGPoint(x: 0.0, y: 1.0), CGPoint(x: 1.0, y: 0.0))
//    case .topLeftBottomRight:
//      return (CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1, y: 1))
//    case .horizontal:
//      return (CGPoint(x: 0.0, y: 0.5), CGPoint(x: 1.0, y: 0.5))
//    case .vertical:
//      return (CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 1.0))
//    }
//  }
//}
//
//extension UIView {
//  public func applyGradient(with colours: [UIColor], locations: [NSNumber]? = nil) {
//    let gradient = CAGradientLayer()
//    gradient.frame = bounds
//    gradient.colors = colours.map { $0.cgColor }
//    gradient.locations = locations
//    layer.insertSublayer(gradient, at: 0)
//  }
//
//  public func applyGradient(with colours: [UIColor], gradient orientation: GradientOrientation) {
//    let gradient = CAGradientLayer()
//    gradient.frame = bounds
//    gradient.colors = colours.map { $0.cgColor }
//    gradient.startPoint = orientation.startPoint
//    gradient.endPoint = orientation.endPoint
//    layer.insertSublayer(gradient, at: 0)
//  }
//}
