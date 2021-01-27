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
  
  fileprivate let nameUser: String?
  fileprivate let emailUser: String?
  
  public init(nameUser: String?, emailUser: String?) {
    self.nameUser = nameUser
    self.emailUser = emailUser
  }
}

final class ProfileCell: UICollectionViewCell, Reusable {

  private let nameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Font.dinAlternateBold(30)
    label.textColor = .dark
    return label
  }()
  
  private let emailLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Font.bold(20)
    label.textColor = .blueGray
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
    
    addSubview(nameLabel)
    NSLayoutConstraint.activate([
      nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
    ])
    
    addSubview(emailLabel)
    NSLayoutConstraint.activate([
      emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
      emailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      emailLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: 20),
    ])
    
    addSubview(cursorView)
    NSLayoutConstraint.activate([
      cursorView.centerYAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 1),
      cursorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
      cursorView.widthAnchor.constraint(equalToConstant: 10),
      cursorView.heightAnchor.constraint(equalToConstant: 18),
    ])
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError() }

  static func height() -> CGFloat {
    170
  }
}

extension ProfileCell: Decoratable {
  
  typealias ViewModel = ProfileCellViewModel
  
  func decorate(model: ViewModel) {
    nameLabel.text = model.nameUser
    emailLabel.text = model.emailUser
  }
}
