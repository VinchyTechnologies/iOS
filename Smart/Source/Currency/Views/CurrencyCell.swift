//
//  CurrencyCell.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 2/25/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core
import Display
import StringFormatting
import UIKit

// MARK: - CurrencyCellViewModel

public struct CurrencyCellViewModel: ViewModelProtocol {
  public let code: String

  fileprivate let title: String?
  fileprivate let isSelected: Bool?

  public init(
    title: String?,
    isSelected: Bool?,
    code: String)
  {
    self.title = title
    self.isSelected = isSelected
    self.code = code
  }
}

// MARK: - C

private enum C {
  static func iconBackgroundColor(isSelected: Bool) -> UIColor { isSelected ? .accent : .white }
  static func iconBorderColor(isSelected: Bool) -> UIColor? { isSelected ? nil : .lightGray }
  static func iconBorderWidth(isSelected: Bool) -> CGFloat { isSelected ? 0 : 1 }
}

// MARK: - CurrencyCell

final class CurrencyCell: UITableViewCell, Reusable {

  // MARK: Lifecycle

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    selectionStyle = .none

    contentView.addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
    ])

    contentView.addSubview(checkBox)
    checkBox.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      checkBox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
      checkBox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      checkBox.widthAnchor.constraint(equalToConstant: 25),
      checkBox.heightAnchor.constraint(equalToConstant: 25),
    ])
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Private

  private let checkBox: UIImageView = {
    let checkBox = UIImageView()
    checkBox.translatesAutoresizingMaskIntoConstraints = false
    checkBox.image = UIImage(named: "checkmark")?.withRenderingMode(.alwaysTemplate)
    checkBox.tintColor = .white
    checkBox.contentMode = .scaleAspectFit
    checkBox.layer.cornerRadius = 4
    checkBox.layer.borderWidth = 1
    checkBox.layer.borderColor = UIColor.lightGray.cgColor

    return checkBox
  }()

  private let label: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Font.bold(16)
    label.textColor = .dark

    return label
  }()
}

// MARK: Decoratable

extension CurrencyCell: Decoratable {
  typealias ViewModel = CurrencyCellViewModel

  func decorate(model: ViewModel) {
    label.text = model.title
    let isSelected = model.isSelected
    checkBox.backgroundColor = C.iconBackgroundColor(isSelected: isSelected ?? false)
    checkBox.layer.borderColor = C.iconBorderColor(isSelected: isSelected ?? false)?.cgColor
    checkBox.layer.borderWidth = C.iconBorderWidth(isSelected: isSelected ?? false)
  }
}
