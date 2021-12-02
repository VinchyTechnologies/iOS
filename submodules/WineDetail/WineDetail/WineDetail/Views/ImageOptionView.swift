//
//  ImageOptionView.swift
//  Smart
//
//  Created by Алексей Смирнов on 10.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import Epoxy
import UIKit

// MARK: - ImageOptionViewViewModel

public struct ImageOptionViewViewModel: Equatable {
  fileprivate let image: UIImage?
  fileprivate let titleText: String?
  fileprivate let isSelected: Bool

  public init(image: UIImage?, titleText: String?, isSelected: Bool) {
    self.image = image
    self.titleText = titleText
    self.isSelected = isSelected
  }
}

// MARK: - ImageOptionView

public final class ImageOptionView: UIView, EpoxyableView {

  // MARK: Lifecycle

  public init(style: Style) {
    self.style = style
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false

    backgroundColor = .option
    layer.cornerRadius = 15
    clipsToBounds = true

    [imageView, titleLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

    titleLabel.font = Font.with(size: 20, design: .round, traits: .bold)
    titleLabel.textColor = .dark

    imageView.tintColor = .dark

    addSubview(imageView)
    addSubview(titleLabel)

    NSLayoutConstraint.activate([
      imageView.heightAnchor.constraint(equalToConstant: 50),
      imageView.widthAnchor.constraint(equalToConstant: 50),
      imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      imageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Public

  public struct Style: Hashable {
  }

  public typealias Content = ImageOptionViewViewModel

  public func setContent(_ content: Content, animated: Bool) {
    if let named = content.image {
      imageView.image = named
    } else {
      imageView.image = nil
    }
    titleLabel.text = content.titleText

    setSelected(flag: content.isSelected, animated: false)
  }

  // MARK: Internal

  static func size(for content: Content) -> CGSize {
    let height: CGFloat = 100
    let width = (content.titleText?.width(usingFont: Font.with(size: 20, design: .round, traits: .bold)) ?? 0) + 30
    return CGSize(width: max(width, 130), height: height)
  }

  // MARK: Private

  private let style: Style
  private let imageView = UIImageView()
  private let titleLabel = UILabel()

  private func setSelected(flag: Bool, animated: Bool) {
    if animated {
      UIView.animate(withDuration: 0.15, delay: 0, options: .transitionCrossDissolve, animations: {
        self.backgroundColor = flag ? .accent : .option
        self.titleLabel.textColor = flag ? .white : .dark
        self.imageView.alpha = flag ? 0 : 1
      }, completion: nil)
    } else {
      backgroundColor = flag ? .accent : .option
      titleLabel.textColor = flag ? .white : .dark
      imageView.alpha = flag ? 0 : 1
    }
  }
}
