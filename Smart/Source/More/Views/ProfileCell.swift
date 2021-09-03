//
//  ProfileCell.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 1/25/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit

// MARK: - ProfileCellViewModel

public struct ProfileCellViewModel: ViewModelProtocol {
  fileprivate let userNameText: String?
  fileprivate let userEmailText: String?

  public init(nameUser: String?, emailUser: String?) {
    userNameText = nameUser
    userEmailText = emailUser
  }
}

// MARK: - ProfileCell

final class ProfileCell: UICollectionViewCell, Reusable {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)

    contentView.addSubview(accessoryIndicatorView)
    NSLayoutConstraint.activate([
      accessoryIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
      accessoryIndicatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
      accessoryIndicatorView.widthAnchor.constraint(equalToConstant: 10),
      accessoryIndicatorView.heightAnchor.constraint(equalToConstant: 18),
    ])

    contentView.addSubview(vStack)
    vStack.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      vStack.topAnchor.constraint(equalTo: contentView.topAnchor),
      vStack.trailingAnchor.constraint(equalTo: accessoryIndicatorView.leadingAnchor, constant: -5),
      vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
    ])
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Internal

  static func height() -> CGFloat {
    54
  }

  // MARK: Private

  private let nameLabel: UILabel = {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = Font.bold(25)
    $0.textColor = .dark
    $0.adjustsFontSizeToFitWidth = true
    $0.minimumScaleFactor = 0.1
    return $0
  }(UILabel())

  private let emailLabel: UILabel = {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = Font.medium(15)
    $0.textColor = .blueGray
    return $0
  }(UILabel())

  private let accessoryIndicatorView: UIImageView = {
    $0.translatesAutoresizingMaskIntoConstraints = false
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .semibold, scale: .default)
    $0.image = UIImage(systemName: "chevron.right", withConfiguration: imageConfig)?.withTintColor(.blueGray, renderingMode: .alwaysOriginal)
    $0.contentMode = .scaleAspectFit
    return $0
  }(UIImageView())

  private lazy var vStack: UIStackView = {
    $0.axis = .vertical
    $0.distribution = .fillEqually
    return $0
  }(UIStackView(arrangedSubviews: [nameLabel, emailLabel]))
}

// MARK: Decoratable

extension ProfileCell: Decoratable {
  typealias ViewModel = ProfileCellViewModel

  func decorate(model: ViewModel) {
    nameLabel.text = model.userNameText
    emailLabel.text = model.userEmailText
  }
}
