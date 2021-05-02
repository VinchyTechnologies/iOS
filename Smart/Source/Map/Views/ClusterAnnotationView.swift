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

final class LocationDataMapClusterView: MKAnnotationView {
  
  override var annotation: MKAnnotation? {
    didSet {
      guard let annotation = annotation as? MKClusterAnnotation else {
        return
      }
      
      countLabel.text = annotation.memberAnnotations.count < 100 ? "\(annotation.memberAnnotations.count)" : "99+"
    }
  }
  
  // MARK: - Private Properties
  
  private let countLabel: UILabel = {
    $0.backgroundColor = .accent
    $0.textColor = .white
    $0.textAlignment = .center
    $0.font = Font.with(size: 18, design: .round, traits: .bold)
    return $0
  }(UILabel())

  // MARK: - Initializers
  
  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    
    displayPriority = .defaultHigh
    collisionMode = .circle
    
    frame = CGRect(x: 0, y: 0, width: 36, height: 36)
    centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
    
    addSubview(countLabel)
    countLabel.fill()
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError() }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    countLabel.layer.cornerRadius = countLabel.frame.height / 2
    countLabel.clipsToBounds = true
  }
  
}
