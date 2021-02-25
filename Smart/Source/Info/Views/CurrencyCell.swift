//
//  CurrencyCell.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 2/19/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

public struct CurrencyCellViewModel: ViewModelProtocol {
  
  fileprivate let titleText: String?
  fileprivate let icon: UIImage?
  
  public init(titleText: String?, icon: UIImage?) {
    self.titleText = titleText
    self.icon = icon
  }
}

final class CurrencyCell: UICollectionViewCell, Reusable {
  
  private let currencyImage: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(named: "phone")?.withRenderingMode(.alwaysTemplate)
    imageView.tintColor = .dark
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  private let currencyLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Font.dinAlternateBold(18)
    label.textColor = .dark
    return label
  }()
  
  private let cursorView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(named: "fill1Copy")
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.addSubview(currencyImage)
    NSLayoutConstraint.activate([
      currencyImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      currencyImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
      currencyImage.widthAnchor.constraint(equalToConstant: 20),
      currencyImage.heightAnchor.constraint(equalToConstant: 20),
    ])
    
    contentView.addSubview(currencyLabel)
    NSLayoutConstraint.activate([
      currencyLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      currencyLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
      currencyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 80),
      currencyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      currencyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      currencyLabel.heightAnchor.constraint(equalToConstant: 60),
    ])
    
    contentView.addSubview(cursorView)
    NSLayoutConstraint.activate([
      cursorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      cursorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
      cursorView.widthAnchor.constraint(equalToConstant: 6),
      cursorView.heightAnchor.constraint(equalToConstant: 10),
    ])
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError() }

  static func height() -> CGFloat {
    60
  }
}
extension CurrencyCell: Decoratable {
  
  typealias ViewModel = CurrencyCellViewModel
  
  func decorate(model: ViewModel) {
    currencyLabel.text = model.titleText
    currencyImage.image = model.icon?.withRenderingMode(.alwaysTemplate)
  }
}
