//
//  SocialMediaCell.swift
//  Coffee
//
//  Created by Алексей Смирнов on 11/04/2019.
//  Copyright © 2019 Алексей Смирнов. All rights reserved.
//

import UIKit
import Display
import StringFormatting
// swiftlint:disable all

public struct StandartImageViewModel: ViewModelProtocol, Hashable {
  
  fileprivate let titleText: String?
  
  public init(titleText: String?) {
    self.titleText = titleText
  }
}

final class StandartImageView: UIImageView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    contentMode = .scaleAspectFit
  }
  
  override init(image: UIImage?) {
    super.init(image: image)
    translatesAutoresizingMaskIntoConstraints = false
    contentMode = .scaleAspectFit
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError() }
}

protocol SocialMediaCellDelegate: AnyObject {
  func didClickVK()
  func didClickInstagram()
}

final class SocialMediaCell: HighlightCollectionCell, Reusable {
  
  static func height() -> CGFloat {
    return 60
  }
  
  weak var delegate: SocialMediaCellDelegate?
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Font.bold(20)
    label.text = localized("we_are_in_social_networks").firstLetterUppercased()
    label.textColor = .dark
    
    return label
  }()
  
  private let vk = StandartImageView(image: UIImage(named: "vk3")!.withRenderingMode(.alwaysTemplate))
  
  private let instagram = StandartImageView(image: UIImage(named: "inst2")!.withRenderingMode(.alwaysTemplate))
  
  init(delegate: SocialMediaCellDelegate) {
    super.init(frame: .zero)
    self.delegate = delegate
    
    let tapVK = UITapGestureRecognizer(target: self, action: #selector(actionVK))
    vk.addGestureRecognizer(tapVK)
    
    let tapInstagram = UITapGestureRecognizer(target: self, action: #selector(actionInstagram))
    instagram.addGestureRecognizer(tapInstagram)
    
    addSubview(titleLabel)
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])
    
    vk.tintColor = .dark
    instagram.tintColor = .dark
    
    vk.heightAnchor.constraint(equalToConstant: 80).isActive = true
    instagram.heightAnchor.constraint(equalToConstant: 70).isActive = true
    
    vk.isUserInteractionEnabled = true
    instagram.isUserInteractionEnabled = true
    isUserInteractionEnabled = true
    
    let stackView = UIStackView(arrangedSubviews: [vk, instagram])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.alignment = .center
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.isUserInteractionEnabled = true
    
    addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
      stackView.heightAnchor.constraint(equalToConstant: 80)
    ])
  }

  required init?(coder aDecoder: NSCoder) { fatalError() }
  
  @objc private func actionVK() {
    delegate?.didClickVK()
  }
  
  @objc private func actionInstagram() {
    delegate?.didClickInstagram()
  }
}

extension SocialMediaCell: Decoratable {
  
  typealias ViewModel = StandartImageViewModel
  
  func decorate(model: ViewModel) {
    titleLabel.text = model.titleText
  }
}
