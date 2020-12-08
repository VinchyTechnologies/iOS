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

final class RateAppCell: UITableViewCell {

  let emojiLabel = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    selectionStyle = .none
    backgroundColor = UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
      if UITraitCollection.userInterfaceStyle == .dark {
        return .secondarySystemBackground
      } else {
        return UIColor(red: 241 / 255, green: 243 / 255, blue: 246 / 255, alpha: 1.0)
      }
    }

    emojiLabel.translatesAutoresizingMaskIntoConstraints = false
    emojiLabel.text = traitCollection.userInterfaceStyle == .dark ? "👍🏿" : "👍"
    emojiLabel.textAlignment = .center
    emojiLabel.font = Font.regular(50.0)
    
    addSubview(emojiLabel)
    NSLayoutConstraint.activate([
      emojiLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      emojiLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      emojiLabel.widthAnchor.constraint(equalToConstant: 100),
      emojiLabel.heightAnchor.constraint(equalToConstant: 100),
    ])
    
    let rateTextLabel = UILabel()
    rateTextLabel.translatesAutoresizingMaskIntoConstraints = false
    rateTextLabel.text = localized("rate_our_app").firstLetterUppercased()
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

}
