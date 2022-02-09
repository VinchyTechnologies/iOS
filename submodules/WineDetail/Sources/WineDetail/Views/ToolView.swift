//
//  ToolView.swift
//  Smart
//
//  Created by Aleksei Smirnov on 25.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import DisplayMini
import EpoxyCore
import UIKit

// MARK: - ToolCollectionCellViewModel

struct ToolCollectionCellViewModel: ViewModelProtocol, Equatable {
  fileprivate let price: String?
  fileprivate let isLiked: Bool
  fileprivate let isAppClip: Bool

  public init(price: String?, isLiked: Bool, isAppClip: Bool) {
    self.price = price
    self.isLiked = isLiked
    self.isAppClip = isAppClip
  }
}

// MARK: - ToolCollectionCellDelegate

protocol ToolCollectionCellDelegate: AnyObject {
  func didTapShare(_ button: UIButton)
  func didTapLike(_ button: UIButton)
  func didTapPrice(_ button: UIButton)
}

// MARK: - ToolView

final class ToolView: UIView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    self.style = style
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false

    [shareButton, likeButton, priceButton].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.backgroundColor = .option
      $0.layer.cornerRadius = 25
      $0.clipsToBounds = true
    }

    addSubview(shareButton)
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium, scale: .default)
    shareButton.setImage(UIImage(systemName: "square.and.arrow.up", withConfiguration: imageConfig), for: .normal)
    shareButton.tintColor = .dark
    shareButton.addTarget(self, action: #selector(didTapShareButton(_:)), for: .touchUpInside)

    addSubview(priceButton)
    priceButton.backgroundColor = .accent
    priceButton.contentEdgeInsets = .init(top: 0, left: 18, bottom: 0, right: 18)
    priceButton.addTarget(self, action: #selector(didTapPriceButton(_:)), for: .touchUpInside)

    let spaceBetweenShareAndPrice = UILayoutGuide()
    addLayoutGuide(spaceBetweenShareAndPrice)

    addSubview(likeButton)
    likeButton.tintColor = .dark
    likeButton.setImage(UIImage(systemName: "heart", withConfiguration: imageConfig), for: .normal)
    likeButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: imageConfig), for: .selected)
    likeButton.addTarget(self, action: #selector(didTapLikeButton(_:)), for: .touchUpInside)

    NSLayoutConstraint.activate([
      shareButton.leadingAnchor.constraint(equalTo: leadingAnchor),
      shareButton.heightAnchor.constraint(equalToConstant: 50),
      shareButton.widthAnchor.constraint(equalToConstant: 50),
      shareButton.centerYAnchor.constraint(equalTo: centerYAnchor),

      priceButton.trailingAnchor.constraint(equalTo: trailingAnchor),
      priceButton.heightAnchor.constraint(equalToConstant: 50),
      priceButton.centerYAnchor.constraint(equalTo: centerYAnchor),

      spaceBetweenShareAndPrice.leadingAnchor.constraint(equalTo: shareButton.trailingAnchor),
      spaceBetweenShareAndPrice.trailingAnchor.constraint(equalTo: priceButton.leadingAnchor),
      spaceBetweenShareAndPrice.heightAnchor.constraint(equalTo: heightAnchor),

      likeButton.widthAnchor.constraint(equalToConstant: 50),
      likeButton.heightAnchor.constraint(equalToConstant: 50),
      likeButton.centerXAnchor.constraint(equalTo: spaceBetweenShareAndPrice.centerXAnchor),
      likeButton.centerYAnchor.constraint(equalTo: spaceBetweenShareAndPrice.centerYAnchor),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  struct Style: Hashable {
  }

  typealias Content = ToolCollectionCellViewModel

  static var height: CGFloat {
    48
  }

  weak var delegate: ToolCollectionCellDelegate?

  let likeButton = UIButton()

  func setContent(_ content: Content, animated: Bool) {
    self.content = content
    let title = NSAttributedString(
      string: content.price ?? "0.00",
      font: Font.with(size: 20, design: .round, traits: .bold),
      textColor: .white,
      paragraphAlignment: .center)

    priceButton.setAttributedTitle(title, for: .normal)
    likeButton.isSelected = content.isLiked
  }

  // MARK: Private

  private var content: Content?

  private let style: Style
  private let shareButton = UIButton(type: .system)
  private let priceButton = Button()

  @objc
  private func didTapShareButton(_ button: UIButton) {
    delegate?.didTapShare(button)
  }

  @objc
  private func didTapPriceButton(_ button: UIButton) {
    delegate?.didTapPrice(button)
  }

  @objc
  private func didTapLikeButton(_ button: UIButton) {
    guard let content = content else {
      return
    }
    if !content.isAppClip {
      button.isSelected = !button.isSelected
    }
    delegate?.didTapLike(button)
  }
}
