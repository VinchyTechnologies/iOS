//
//  SeparatorFooter.swift
//  Smart
//
//  Created by Aleksei Smirnov on 13.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit

final class SeparatorFooter: UICollectionReusableView, Reusable {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    let line = UIView()
    line.backgroundColor = .systemGray5
    
    addSubview(line)
    line.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      line.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      line.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      line.bottomAnchor.constraint(equalTo: bottomAnchor),
      line.heightAnchor.constraint(equalToConstant: 0.8),
    ])
  }
  
  required init?(coder: NSCoder) { fatalError() }
  
}
