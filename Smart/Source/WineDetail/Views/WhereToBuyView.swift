//
//  WhereToBuyView.swift
//  Smart
//
//  Created by Алексей Смирнов on 30.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import Epoxy
import UIKit

// MARK: - WhereToBuyCellViewModel

struct WhereToBuyCellViewModel: ViewModelProtocol, Equatable {
  let affilatedId: Int
  fileprivate let imageURL: String?
  fileprivate let titleText: String?
  fileprivate let subtitleText: String?

  init(affilatedId: Int, imageURL: String?, titleText: String?, subtitleText: String?) {
    self.affilatedId = affilatedId
    self.imageURL = imageURL
    self.titleText = titleText
    self.subtitleText = subtitleText
  }
}

// MARK: - WhereToBuyView

final class WhereToBuyView: UIView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    self.style = style
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false

    backgroundColor = style.backgroundColor

    titleLabel.numberOfLines = 2
    subtitleLabel.numberOfLines = 2

    stackView.axis = .vertical
    stackView.spacing = 2

    hStackView.axis = .horizontal
    hStackView.alignment = .center
    hStackView.spacing = 4

    addSubview(hStackView)
    hStackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      hStackView.topAnchor.constraint(equalTo: topAnchor, constant: 7),
      hStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
      hStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
      hStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  struct Style: Hashable {
    let backgroundColor: UIColor
  }

  typealias Content = WhereToBuyCellViewModel

  static func height(width: CGFloat, content: Content) -> CGFloat {
    var height: CGFloat = 0
    if content.imageURL == nil {
      if let titleText = content.titleText {
        height += titleText.height(forWidth: width - 12 - 4 - 48, font: Font.medium(20), numberOfLines: 2)
      }
      if let subtitleText = content.subtitleText {
        height += subtitleText.height(forWidth: width - 12 - 4 - 48, font: Font.regular(14), numberOfLines: 2)
      }

      if content.titleText != nil && content.subtitleText != nil {
        height += 2
      }

    } else {
      if let titleText = content.titleText {
        height += titleText.height(forWidth: width - 12 - 4 - 50 - 4 - 48, font: Font.medium(20), numberOfLines: 2)
      }
      if let subtitleText = content.subtitleText {
        height += subtitleText.height(forWidth: width - 12 - 4 - 50 - 4 - 48, font: Font.regular(14), numberOfLines: 2)
      }

      if content.titleText != nil && content.subtitleText != nil {
        height += 2
      }
    }

    if height == 0 {
      return 0
    }

    height = ceil(height)
    return max(height + 7 + 7, 50)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    imageView.layer.cornerRadius = imageView.frame.height / 2
    imageView.clipsToBounds = true
  }

  func setContent(_ content: Content, animated: Bool) {
    if content.imageURL == nil {
      imageView.isHidden = true
    } else {
      imageView.isHidden = false
      imageView.loadImage(url: content.imageURL?.toURL)
    }

    titleLabel.attributedText = NSAttributedString(
      string: content.titleText ?? "",
      font: Font.medium(20),
      textColor: .dark)

    titleLabel.isHidden = content.titleText == nil

    subtitleLabel.attributedText = NSAttributedString(
      string: content.subtitleText ?? "",
      font: Font.regular(14),
      textColor: .blueGray)

    subtitleLabel.isHidden = content.subtitleText == nil
  }

  // MARK: Private

  private let style: Style
  private lazy var stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
  private lazy var hStackView = UIStackView(arrangedSubviews: [imageView, stackView, accessoryImageView])
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

// MARK: HighlightableView

extension WhereToBuyView: HighlightableView {
  func didHighlight(_ isHighlighted: Bool) {
    UIView.animate(
      withDuration: 0.15,
      delay: 0,
      options: [.beginFromCurrentState, .allowUserInteraction])
    {
      self.hStackView.transform = isHighlighted
        ? CGAffineTransform(scaleX: 0.95, y: 0.95)
        : .identity
    }
  }
}
