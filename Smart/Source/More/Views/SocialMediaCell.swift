//
//  SocialMediaCell.swift
//  Coffee
//
//  Created by Алексей Смирнов on 11/04/2019.
//  Copyright © 2019 Алексей Смирнов. All rights reserved.
//

import Display
import StringFormatting
import UIKit

// MARK: - StandartImageViewModel

// swiftlint:disable all

public struct StandartImageViewModel: ViewModelProtocol, Hashable {
  fileprivate let titleText: String?

  public init(titleText: String?) {
    self.titleText = titleText
  }
}

// MARK: - SocialMediaCellDelegate

protocol SocialMediaCellDelegate: AnyObject {
  func didClickVK()
  func didClickInstagram()
}

// MARK: - SocialMediaCell

final class SocialMediaCell: UICollectionViewCell, Reusable {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)

    let tapVK = UITapGestureRecognizer(target: self, action: #selector(actionVK))
    vk.addGestureRecognizer(tapVK)

    let tapInstagram = UITapGestureRecognizer(target: self, action: #selector(actionInstagram))
    instagram.addGestureRecognizer(tapInstagram)

    addSubview(titleLabel)
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])

    vk.tintColor = .dark
    instagram.tintColor = .dark

    vk.heightAnchor.constraint(equalToConstant: 40).isActive = true
    instagram.heightAnchor.constraint(equalToConstant: 40).isActive = true

    telegram.heightAnchor.constraint(equalToConstant: 40).isActive = true

    vk.isUserInteractionEnabled = true
    instagram.isUserInteractionEnabled = true
    isUserInteractionEnabled = true

    vk.tintColor = .accent
    vk.contentMode = .scaleAspectFit
    instagram.tintColor = .accent
    instagram.contentMode = .scaleAspectFit

    telegram.tintColor = .accent
    telegram.contentMode = .scaleAspectFit

    let stackView = UIStackView(arrangedSubviews: [instagram, vk, telegram])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.alignment = .center
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.isUserInteractionEnabled = true

    addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
      stackView.heightAnchor.constraint(equalToConstant: 40),
    ])
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Internal

  weak var delegate: SocialMediaCellDelegate?

  static func height() -> CGFloat {
    100
  }

  // MARK: Private

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Font.bold(20)
    label.text = localized("we_are_in_social_networks").firstLetterUppercased()
    label.textColor = .dark

    return label
  }()

  private let vk = UIImageView(image: UIImage(named: "facebook")!.withRenderingMode(.alwaysTemplate))

  private let instagram = UIImageView(image: UIImage(named: "inst2")!.withRenderingMode(.alwaysTemplate))

  private let telegram = UIImageView(image: UIImage(named: "telegram")!.withRenderingMode(.alwaysTemplate))

  @objc
  private func actionVK() {
    delegate?.didClickVK()
  }

  @objc
  private func actionInstagram() {
    delegate?.didClickInstagram()
  }
}

// MARK: Decoratable

extension SocialMediaCell: Decoratable {
  typealias ViewModel = StandartImageViewModel

  func decorate(model: ViewModel) {
    titleLabel.text = localized("we_are_in_social_networks").firstLetterUppercased() //model.titleText
  }
}
