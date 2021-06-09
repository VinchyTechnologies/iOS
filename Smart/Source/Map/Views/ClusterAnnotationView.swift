//
//  ClusterAnnotationView.swift
//  Smart
//
//  Created by Алексей Смирнов on 29.04.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import MapKit
import UIKit

fileprivate enum C {
  static let font = Font.with(size: 18, design: .round, traits: .bold)
}

final class LocationDataMapClusterView: MKAnnotationView {
  
  // MARK: - Internal Properties
  
  override var annotation: MKAnnotation? {
    didSet {
      guard let annotation = annotation as? MKClusterAnnotation else {
        return
      }
      let text = getCountText(count: annotation.memberAnnotations.count)
      countLabel.text = text
      let side: CGFloat = max(36, text.width(usingFont: C.font) + 8)
      frame = CGRect(
        x: 0,
        y: 0,
        width: side,
        height: side)
    }
  }
  
  // MARK: - Private Properties
  
  private let countLabel: UILabel = {
    $0.backgroundColor = .accent
    $0.textColor = .white
    $0.textAlignment = .center
    $0.font = C.font
    return $0
  }(UILabel())

  // MARK: - Initializers
  
  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    
    displayPriority = .defaultHigh
    if #available(iOS 14.0, *) {
      collisionMode = .rectangle
    } else {
      collisionMode = .rectangle
    }
        
    addSubview(countLabel)
    countLabel.fill()
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError() }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    countLabel.layer.cornerRadius = countLabel.frame.height / 2
    countLabel.clipsToBounds = true
    centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
  }
  
  override func willMove(toSuperview newSuperview: UIView?) {
    super.willMove(toSuperview: newSuperview)
    addBounceAnnimation()
  }
  
  // MARK: - Private Methods
  
  private func getCountText(count: Int) -> String {
    if count > 500 {
        return "500+"
    } else if count > 100 {
        return "100+"
    } else if count > 50 {
        return "50+"
    } else if count > 25 {
        return "25+"
    } else if count > 10 {
        return "10+"
    } else {
        return String(count)
    }
  }
  
  private func addBounceAnnimation() {
    let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
    
    bounceAnimation.values = [NSNumber(value: 0.05), NSNumber(value: 1.1), NSNumber(value: 0.9), NSNumber(value: 1)]
    bounceAnimation.duration = 0.6
    
    var timingFunctions = [AnyHashable](repeating: 0, count: bounceAnimation.values?.count ?? 0)
    for _ in 0..<(bounceAnimation.values?.count ?? 0) {
      timingFunctions.append(CAMediaTimingFunction(name: .easeInEaseOut))
    }
    bounceAnimation.timingFunctions = timingFunctions as? [CAMediaTimingFunction]
    
    bounceAnimation.isRemovedOnCompletion = false
    
    layer.add(bounceAnimation, forKey: "bounce")
  }
}
