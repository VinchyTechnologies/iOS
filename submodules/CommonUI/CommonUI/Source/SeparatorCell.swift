//
//  SeparatorCell.swift
//  CommonUI
//
//  Created by Алексей Смирнов on 25.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit

public final class SeparatorCell: UICollectionViewCell, Reusable {
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    let line = UIView()
    line.backgroundColor = .separator
    
    contentView.addSubview(line)
    line.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      line.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      line.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      line.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      line.heightAnchor.constraint(equalToConstant: 0.8),
    ])
  }
  
  required init?(coder: NSCoder) { fatalError() }
  
}
