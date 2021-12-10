//
//  SocialMediaCell.swift
//  Coffee
//
//  Created by Алексей Смирнов on 11/04/2019.
//  Copyright © 2019 Алексей Смирнов. All rights reserved.
//

import DisplayMini
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
  func didTapInstagram()
  func didTapTelegram()
  func didTapFacebook()
}

// MARK: - SocialMediaCell

final class SocialMediaCell: UICollectionViewCell, Reusable {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)

//    let tapVK = UITapGestureRecognizer(target: self, action: #selector(actionVK))
//    vk.addGestureRecognizer(tapVK)

    let tapInstagram = UITapGestureRecognizer(target: self, action: #selector(actionInstagram))
    instagram.addGestureRecognizer(tapInstagram)

    let tapTelegram = UITapGestureRecognizer(target: self, action: #selector(didTapTelegram))
    telegram.addGestureRecognizer(tapTelegram)

    let tapFacebook = UITapGestureRecognizer(target: self, action: #selector(didTapFacebook))
    fb.addGestureRecognizer(tapFacebook)

    addSubview(titleLabel)
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])

    fb.tintColor = .dark
    instagram.tintColor = .dark

    fb.heightAnchor.constraint(equalToConstant: 40).isActive = true
    instagram.heightAnchor.constraint(equalToConstant: 40).isActive = true

    telegram.heightAnchor.constraint(equalToConstant: 30).isActive = true
    telegram.widthAnchor.constraint(equalToConstant: 30).isActive = true

    fb.isUserInteractionEnabled = true
    instagram.isUserInteractionEnabled = true
    telegram.isUserInteractionEnabled = true
    isUserInteractionEnabled = true

    fb.tintColor = .accent
    fb.contentMode = .scaleAspectFit
    instagram.tintColor = .accent
    instagram.contentMode = .scaleAspectFit

    telegram.tintColor = .accent
    telegram.contentMode = .scaleAspectFit

    let stackView = UIStackView(arrangedSubviews: [instagram, fb, telegram])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.alignment = .center
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.isUserInteractionEnabled = true
    stackView.spacing = 8

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
    label.textColor = .dark

    return label
  }()

  private let fb = UIImageView(image: UIImage(named: "fb")!.withRenderingMode(.alwaysTemplate))

  private let instagram = UIImageView(image: UIImage(named: "insta")!.withRenderingMode(.alwaysTemplate))

  private let telegram = UIImageView(image: UIImage(named: "tg")!.withRenderingMode(.alwaysTemplate))

  @objc
  private func actionInstagram() {
    delegate?.didTapInstagram()
  }

  @objc
  private func didTapTelegram() {
    delegate?.didTapTelegram()
  }

  @objc
  private func didTapFacebook() {
    delegate?.didTapFacebook()
  }
}

// MARK: Decoratable

extension SocialMediaCell: Decoratable {
  typealias ViewModel = StandartImageViewModel

  func decorate(model: ViewModel) {
    titleLabel.text = model.titleText
  }
}
