//
//  RateAppCell.swift
//  Coffee
//
//  Created by Алексей Смирнов on 11/04/2019.
//  Copyright © 2019 Алексей Смирнов. All rights reserved.
//

import UIKit
import Display
import StringFormatting

public struct RateAppCellViewModel: ViewModelProtocol {
  
  fileprivate let titleText: String?
  fileprivate let emojiLabel: String?
  
  public init(titleText: String?, emojiLabel: String?) {
    self.titleText = titleText
    self.emojiLabel = emojiLabel
  }
}

final class RateAppCell: UICollectionViewCell, Reusable {

  private let emojiLabel = UILabel()
  private let rateTextLabel = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .option
    
    emojiLabel.translatesAutoresizingMaskIntoConstraints = false
    emojiLabel.textAlignment = .center
    emojiLabel.font = Font.regular(50.0)
    emojiLabel.text = traitCollection.userInterfaceStyle == .dark ? "👍🏿" : "👍"
    
    addSubview(emojiLabel)
    NSLayoutConstraint.activate([
      emojiLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      emojiLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      emojiLabel.widthAnchor.constraint(equalToConstant: 100),
      emojiLabel.heightAnchor.constraint(equalToConstant: 100),
    ])
    
    rateTextLabel.translatesAutoresizingMaskIntoConstraints = false
    rateTextLabel.font = Font.bold(20)
    rateTextLabel.textAlignment = .center
    
    addSubview(rateTextLabel)
    NSLayoutConstraint.activate([
      rateTextLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor),
      rateTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
      rateTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
      rateTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError() }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    emojiLabel.text = traitCollection.userInterfaceStyle == .dark ? "👍🏿" : "👍"
  }

  static func height() -> CGFloat {
    150
  }

}

extension RateAppCell: Decoratable {
  
  typealias ViewModel = RateAppCellViewModel
  
  func decorate(model: ViewModel) {
    rateTextLabel.text = model.titleText
//    emojiLabel.text = model.emojiLabel
  }
}
