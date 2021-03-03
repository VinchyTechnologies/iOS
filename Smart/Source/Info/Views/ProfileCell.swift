//
//  ProfileCell.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 1/25/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

public struct ProfileCellViewModel: ViewModelProtocol {
  
  fileprivate let userNameText: String?
  fileprivate let userEmailText: String?
  
  public init(nameUser: String?, emailUser: String?) {
    self.userNameText = nameUser
    self.userEmailText = emailUser
  }
}

final class ProfileCell: UICollectionViewCell, Reusable {

  private let nameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Font.bold(25)
    label.textColor = .dark
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.1
    return label
  }()
  
  private let emailLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Font.medium(15)
    label.textColor = .blueGray
    return label
  }()
  
  private let accessoryIndicatorView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(named: "fill1Copy")
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
    
  override init(frame: CGRect) {
    super.init(frame: frame)
        
    contentView.addSubview(nameLabel)
    NSLayoutConstraint.activate([
      nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
    ])
    
//    contentView.addSubview(emailLabel)
//    NSLayoutConstraint.activate([
//      emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
//      emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//      emailLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: 20),
//    ])
    
//    contentView.addSubview(accessoryIndicatorView)
//    NSLayoutConstraint.activate([
//      accessoryIndicatorView.centerYAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 1),
//      accessoryIndicatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
//      accessoryIndicatorView.widthAnchor.constraint(equalToConstant: 10),
//      accessoryIndicatorView.heightAnchor.constraint(equalToConstant: 18),
//    ])
    
//    let line = UIView()
//    line.backgroundColor = .separator
//    addSubview(line)
//    line.translatesAutoresizingMaskIntoConstraints = false
//    NSLayoutConstraint.activate([
//      line.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
//      line.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//      line.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//      line.heightAnchor.constraint(equalToConstant: 0.5),
//    ])
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError() }

  static func height() -> CGFloat {
    50
  }
}

extension ProfileCell: Decoratable {
  
  typealias ViewModel = ProfileCellViewModel
  
  func decorate(model: ViewModel) {
    nameLabel.text = model.userNameText
    emailLabel.text = model.userEmailText
  }
}
