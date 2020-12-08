//
//  Shimmer.swift
//  Display
//
//  Created by Aleksei Smirnov on 22.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

private enum C {
  static let lightColor: UIColor = .shimmerLight
  static let alphaColor: UIColor = .shimmerAlpha
  static let startPoint = CGPoint(x: 1.0, y: 0.6)
  static let endPoint = CGPoint(x: 0.0, y: 0.5)
}

public protocol ShimmeringView where Self: UIView {

  func getShimmering(
    beginTime: CFTimeInterval,
    duration: CFTimeInterval,
    startPoint: CGPoint,
    endPoint: CGPoint)
  -> CAGradientLayer

  func generateShimmeringLayerFrame(
    forSuperframe superframe: CGRect)
  -> CGRect
}

public extension ShimmeringView {
  func getShimmering(
    beginTime: CFTimeInterval,
    duration: CFTimeInterval,
    startPoint: CGPoint,
    endPoint: CGPoint)
    -> CAGradientLayer
  {
    let gradientMask = CAGradientLayer()
    gradientMask.colors = [
      C.alphaColor.cgColor,
      C.lightColor.cgColor,
      C.alphaColor.cgColor
    ]
    gradientMask.frame = generateShimmeringLayerFrame(forSuperframe: bounds)
    gradientMask.startPoint = startPoint
    gradientMask.endPoint = endPoint
    gradientMask.locations = [NSNumber(value: 0.9), NSNumber(value: 0.5), NSNumber(value: 0.1)]

    let shimmer = CABasicAnimation(keyPath: "locations")
    shimmer.fromValue = [NSNumber(value: 0.7), NSNumber(value: 0.5), NSNumber(value: 1.0)]
    shimmer.toValue = [NSNumber(value: 0.0), NSNumber(value: 0.1), NSNumber(value: 0.2)]
    shimmer.duration = duration

    shimmer.fillMode = .forwards
    shimmer.repeatCount = Float.greatestFiniteMagnitude
    shimmer.beginTime = beginTime
    shimmer.isRemovedOnCompletion = false
    gradientMask.add(shimmer, forKey: "shimmer")
    return gradientMask
  }

  func getShimmering(beginTime: CFTimeInterval,
                     duration: CFTimeInterval) -> CAGradientLayer {
    getShimmering(beginTime: beginTime, duration: duration,
                  startPoint: C.startPoint, endPoint: C.endPoint)
  }

  func generateShimmeringLayerFrame(forSuperframe superframe: CGRect) -> CGRect {
    CGRect(
      x: -superframe.width,
      y: 0,
      width: 3 * superframe.width,
      height: superframe.height)
  }
}
