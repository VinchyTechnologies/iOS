//
//  PartnerAnnotationView.swift
//  Smart
//
//  Created by Алексей Смирнов on 28.04.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit
import MapKit
import Display

fileprivate enum C {
  static let font: UIFont = Font.medium(16)
}

final class PartnerAnnotationView: MKAnnotationView, Reusable {
  
  static var reuseId: String {
    PartnerAnnotationView.description()
  }
  
  private let titleLabel: UILabel = {
    $0.backgroundColor = .accent
    $0.font = C.font
    $0.textAlignment = .center
    return $0
  }(UILabel())
  
  var titleText: String = String()
  
  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    
    canShowCallout = false
    
    let triangleViewWidth: CGFloat = 16
    let triangleViewHeight: CGFloat = 10
    
    let titleText: String = (annotation?.title ?? "") ?? ""
        
    titleLabel.text = titleText
        
    let width = titleText.width(usingFont: C.font)
    
    self.frame = .init(
      x: 0,
      y: 0,
      width: width + 16,
      height: titleText.height(forWidth: width, font: C.font) + 8 + triangleViewHeight)

    let triangleView = TriangleView(
      frame: .init(
        x: width / 2,
        y: titleText.height(forWidth: width, font: C.font) + 8,
        width: triangleViewWidth,
        height: triangleViewHeight))
    addSubview(titleLabel)
    addSubview(triangleView)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    let width = titleText.width(usingFont: C.font)
    titleLabel.frame = .init(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height: titleText.height(forWidth: width, font: C.font) + 8)
    titleLabel.layer.cornerRadius = titleLabel.frame.height / 2
    titleLabel.clipsToBounds = true
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError() }
    
}

final class TriangleView: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .clear
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError() }
  
  override func draw(_ rect: CGRect) {
    backgroundColor = .clear
    guard let context = UIGraphicsGetCurrentContext() else { return }
    context.beginPath()
    context.move(to: CGPoint(x: rect.minX, y: rect.minY))
    context.addLine(to: CGPoint(x: rect.maxX / 2.0, y: rect.maxY))
    context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
    context.closePath()
    
    context.setFillColor(UIColor.accent.cgColor)
    context.fillPath()
  }
}
