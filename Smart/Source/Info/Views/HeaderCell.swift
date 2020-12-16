//
//  HeaderCell.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 12/14/20.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display
import StringFormatting

public struct HeaderCellViewModel: ViewModelProtocol, Hashable {
  
  fileprivate let titleText: String?
  
  public init(titleText: String?) {
    self.titleText = titleText
  }
}

final class HeaderCell: HighlightCollectionCell, Reusable {
  
  static func height() -> CGFloat {
    return 60
  }
  
  private let bodyLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Font.dinAlternateBold(18)
    label.textColor = .dark
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(bodyLabel)
    NSLayoutConstraint.activate([
      bodyLabel.topAnchor.constraint(equalTo: topAnchor, constant: 13),
      bodyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
      bodyLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError() }
}

extension HeaderCell: Decoratable {
  
  typealias ViewModel = HeaderCellViewModel
  
  func decorate(model: ViewModel) {
    bodyLabel.text = model.titleText
  }
}
