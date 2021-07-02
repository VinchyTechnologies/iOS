//
//  WhereToBuyCell.swift
//  Smart
//
//  Created by Алексей Смирнов on 30.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import UIKit

// MARK: - WhereToBuyCellViewModel

struct WhereToBuyCellViewModel: ViewModelProtocol {
  fileprivate let imageURL: String?
  fileprivate let titleText: String?
  fileprivate let subtitleText: String?

  init(imageURL: String?, titleText: String?, subtitleText: String?) {
    self.imageURL = imageURL
    self.titleText = titleText
    self.subtitleText = subtitleText
  }
}

// MARK: - WhereToBuyCell

final class WhereToBuyCell: UICollectionViewCell, Reusable {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)

    titleLabel.numberOfLines = 0
    subtitleLabel.numberOfLines = 0

    let stackView = UIStackView(arrangedSubviews: [subtitleLabel, titleLabel])
    stackView.axis = .vertical
    stackView.spacing = 2

    let hStackView = UIStackView(arrangedSubviews: [imageView, stackView, accessoryImageView])
    hStackView.axis = .horizontal
    hStackView.alignment = .center
    hStackView.spacing = 4

    addSubview(hStackView)
    hStackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      hStackView.topAnchor.constraint(equalTo: topAnchor, constant: 7),
      hStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      hStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      hStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7),
    ])
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Private

  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()

  private let imageView: UIImageView = {
    $0.contentMode = .scaleAspectFill
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.widthAnchor.constraint(equalToConstant: 50).isActive = true
    $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
    return $0
  }(UIImageView())

  private let accessoryImageView: UIImageView = {
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .semibold, scale: .default)
    $0.image = UIImage(systemName: "chevron.right", withConfiguration: imageConfig)?.withTintColor(.blueGray, renderingMode: .alwaysOriginal)
    $0.contentMode = .scaleAspectFill
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.widthAnchor.constraint(equalToConstant: 12).isActive = true
    $0.heightAnchor.constraint(equalToConstant: 15).isActive = true
    return $0
  }(UIImageView())
}

// MARK: Decoratable

extension WhereToBuyCell: Decoratable {

  typealias ViewModel = WhereToBuyCellViewModel

  func decorate(model: ViewModel) {

    imageView.loadImage(url: model.imageURL?.toURL)

    titleLabel.attributedText = NSAttributedString(
      string: model.titleText ?? "",
      font: Font.medium(20),
      textColor: .dark)

    titleLabel.isHidden = model.titleText == nil

    subtitleLabel.attributedText = NSAttributedString(
      string: model.subtitleText ?? "",
      font: Font.regular(14),
      textColor: .blueGray)

    subtitleLabel.isHidden = model.subtitleText == nil
  }
}
