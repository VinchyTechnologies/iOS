//
//  CurrencyCell.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 2/19/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit

// MARK: - InfoCurrencyCellViewModel

public struct InfoCurrencyCellViewModel: ViewModelProtocol {
  fileprivate let titleText: String?
  fileprivate let symbolText: String?
  fileprivate let icon: UIImage?

  public init(titleText: String?, symbolText: String?, icon: UIImage?) {
    self.titleText = titleText
    self.symbolText = symbolText
    self.icon = icon
  }
}

// MARK: - InfoCurrencyCell

final class InfoCurrencyCell: UICollectionViewCell, Reusable {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)

    contentView.addSubview(currencyImage)
    NSLayoutConstraint.activate([
      currencyImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      currencyImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
      currencyImage.widthAnchor.constraint(equalToConstant: 20),
      currencyImage.heightAnchor.constraint(equalToConstant: 20),
    ])

    contentView.addSubview(currencyLabel)
    NSLayoutConstraint.activate([
      currencyLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      currencyLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
      currencyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 80),
      currencyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      currencyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      currencyLabel.heightAnchor.constraint(equalToConstant: 60),
    ])

    contentView.addSubview(symbolCurrencyLabel)
    NSLayoutConstraint.activate([
      symbolCurrencyLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      symbolCurrencyLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
      symbolCurrencyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
      symbolCurrencyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      symbolCurrencyLabel.heightAnchor.constraint(equalToConstant: 60),
    ])

    contentView.addSubview(cursorView)
    NSLayoutConstraint.activate([
      cursorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      cursorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
      cursorView.widthAnchor.constraint(equalToConstant: 15),
      cursorView.heightAnchor.constraint(equalToConstant: 15),
    ])
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Internal

  static func height() -> CGFloat {
    60
  }

  // MARK: Private

  private let currencyImage: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.tintColor = .dark
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()

  private let currencyLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Font.dinAlternateBold(18)
    label.textColor = .dark
    return label
  }()

  private let symbolCurrencyLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Font.regular(18)
    label.textColor = .accent
    return label
  }()

  private let cursorView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .semibold, scale: .default)
    imageView.image = UIImage(systemName: "chevron.right", withConfiguration: imageConfig)?.withTintColor(.blueGray, renderingMode: .alwaysOriginal)
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
}

// MARK: Decoratable

extension InfoCurrencyCell: Decoratable {
  typealias ViewModel = InfoCurrencyCellViewModel

  func decorate(model: ViewModel) {
    currencyLabel.text = model.titleText
    symbolCurrencyLabel.text = model.symbolText
    currencyImage.image = model.icon?.withRenderingMode(.alwaysTemplate)
  }
}
