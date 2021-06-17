//
//  CountryTableViewCell.swift
//  CommonUI
//
//  Created by Aleksei Smirnov on 15.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit

// MARK: - CountryTableViewCellViewModel

struct CountryTableViewCellViewModel: ViewModelProtocol {
  fileprivate let flagImage: UIImage?
  fileprivate let titleText: String?
  fileprivate let isCheckBoxed: Bool

  init(flagImage: UIImage?, titleText: String?, isCheckBoxed: Bool) {
    self.flagImage = flagImage
    self.titleText = titleText
    self.isCheckBoxed = isCheckBoxed
  }
}

// MARK: - CountryTableViewCell

final class CountryTableViewCell: UITableViewCell, Reusable {

  // MARK: Lifecycle

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    selectionStyle = .none

    flagImageView.backgroundColor = .blueGray
    flagImageView.contentMode = .scaleAspectFill
    contentView.addSubview(flagImageView)
    flagImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      flagImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      flagImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      flagImageView.heightAnchor.constraint(equalToConstant: 30),
      flagImageView.widthAnchor.constraint(equalToConstant: 45),
    ])

    titleLabel.font = Font.bold(16)
    titleLabel.textColor = .dark

    contentView.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: flagImageView.trailingAnchor, constant: 10),
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
    ])

    checkBox.image = UIImage(named: "checkmark")?.withRenderingMode(.alwaysTemplate)
    checkBox.tintColor = .white
    checkBox.contentMode = .scaleAspectFit
    checkBox.layer.cornerRadius = 4

    contentView.addSubview(checkBox)
    checkBox.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      checkBox.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
      checkBox.centerYAnchor.constraint(equalTo: centerYAnchor),
      checkBox.widthAnchor.constraint(equalToConstant: 25),
      checkBox.heightAnchor.constraint(equalToConstant: 25),
    ])
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Private

  private enum Constants {
    static func iconBackgroundColor(isSelected: Bool) -> UIColor { isSelected ? .accent : .white }
    static func iconBorderColor(isSelected: Bool) -> UIColor? { isSelected ? nil : .lightGray }
    static func iconBorderWidth(isSelected: Bool) -> CGFloat { isSelected ? 0 : 1 }
  }

  private let flagImageView = UIImageView()
  private let titleLabel = UILabel()
  private let checkBox = UIImageView()
}

// MARK: Decoratable

extension CountryTableViewCell: Decoratable {
  typealias ViewModel = CountryTableViewCellViewModel

  func decorate(model: CountryTableViewCellViewModel) {
    flagImageView.image = model.flagImage
    titleLabel.text = model.titleText
    let isSelected = model.isCheckBoxed
    checkBox.backgroundColor = Constants.iconBackgroundColor(isSelected: isSelected)
    checkBox.layer.borderColor = Constants.iconBorderColor(isSelected: isSelected)?.cgColor
    checkBox.layer.borderWidth = Constants.iconBorderWidth(isSelected: isSelected)
  }
}
