//
//  DocCell.swift
//  Coffee
//
//  Created by Алексей Смирнов on 11/04/2019.
//  Copyright © 2019 Алексей Смирнов. All rights reserved.
//

import UIKit
import Display

final class DocCell: UITableViewCell {
  
  private let phoneImage: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(named: "phone")?.withRenderingMode(.alwaysTemplate)
    imageView.tintColor = .dark
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  private let phoneLabel: UILabel = {
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
  
  init(icon: UIImage, text: String) {
    super.init(style: .default, reuseIdentifier: nil)
    
    phoneLabel.text = text
    phoneImage.image = icon.withRenderingMode(.alwaysTemplate)
    
    selectionStyle = .none
    
    contentView.addSubview(phoneImage)
    NSLayoutConstraint.activate([
      phoneImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      phoneImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
      phoneImage.widthAnchor.constraint(equalToConstant: 20),
      phoneImage.heightAnchor.constraint(equalToConstant: 20)
    ])
    
    contentView.addSubview(phoneLabel)
    NSLayoutConstraint.activate([
      phoneLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      phoneLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
      phoneLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 80),
      phoneLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      phoneLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      phoneLabel.heightAnchor.constraint(equalToConstant: 60)
    ])
    
    contentView.addSubview(cursorView)
    NSLayoutConstraint.activate([
      cursorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      cursorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
      cursorView.widthAnchor.constraint(equalToConstant: 6),
      cursorView.heightAnchor.constraint(equalToConstant: 10)
    ])
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError() }
}
