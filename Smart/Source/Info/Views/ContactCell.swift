//
//  ContactCell.swift
//  Coffee
//
//  Created by Алексей Смирнов on 11/04/2019.
//  Copyright © 2019 Алексей Смирнов. All rights reserved.
//

import UIKit
import Display

public struct ContactCellViewModel: ViewModelProtocol {
  
  fileprivate let titleText: String?
  fileprivate let detailText: String?
  fileprivate let icon: UIImage?
  
  public init(titleText: String?, icon: UIImage?, detailText: String?) {
    self.titleText = titleText
    self.icon = icon
    self.detailText = detailText
  }
}

final class ContactCell: UICollectionViewCell, Reusable {

  private let contactImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.tintColor = .dark
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  private let bodyLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Font.dinAlternateBold(18)
    label.textColor = .dark
    return label
  }()
  
  private let detailLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Font.bold(12)
    label.textColor = .blueGray
    return label
  }()
    
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(contactImageView)
    NSLayoutConstraint.activate([
      contactImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      contactImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
      contactImageView.widthAnchor.constraint(equalToConstant: 20),
      contactImageView.heightAnchor.constraint(equalToConstant: 20),
    ])
    
    addSubview(bodyLabel)
    NSLayoutConstraint.activate([
      bodyLabel.topAnchor.constraint(equalTo: topAnchor, constant: 13),
      bodyLabel.leadingAnchor.constraint(equalTo: contactImageView.trailingAnchor, constant: 30),
    ])
    
    addSubview(detailLabel)
    NSLayoutConstraint.activate([
      detailLabel.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 4),
      detailLabel.leadingAnchor.constraint(equalTo: contactImageView.trailingAnchor, constant: 30),
      detailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
      detailLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10),
    ])
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError() }

  static func height() -> CGFloat {
    60
  }

}

extension ContactCell: Decoratable {
  
  typealias ViewModel = ContactCellViewModel
  
  func decorate(model: ViewModel) {
    bodyLabel.text = model.titleText
    contactImageView.image = model.icon
    detailLabel.text = model.detailText
  }
}
