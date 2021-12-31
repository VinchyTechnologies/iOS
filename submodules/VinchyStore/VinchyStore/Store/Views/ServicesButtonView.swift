//
//  ServicesButtonView.swift
//  VinchyStore
//
//  Created by Алексей Смирнов on 27.12.2021.
//

import DisplayMini
import EpoxyCore
import EpoxyLayoutGroups
import UIKit

// MARK: - ServicesButtonView

final class ServicesButtonView: UIView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    self.style = style
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    directionalLayoutMargins = .zero
    layoutMargins = .zero

    addSubview(hStack)
    hStack.translatesAutoresizingMaskIntoConstraints = false
    hStack.constrainToSuperview()
    hStack.axis = .horizontal
    hStack.distribution = .fillEqually
    hStack.spacing = 8
  }

  required init?(coder aDecoder: NSCoder) { fatalError() }

  // MARK: Public

  public struct Behaviors {
    public let didTapLike: (UIButton) -> Void
    public init(didTapLike: @escaping ((UIButton) -> Void)) {
      self.didTapLike = didTapLike
    }
  }

  public func setBehaviors(_ behaviors: Behaviors?) {
    didTapLike = behaviors?.didTapLike
  }

  // MARK: Internal

  struct Style: Hashable {
    init() {

    }
  }
  struct Content: Equatable {

    let isLiked: Bool

    init(isLiked: Bool) {
      self.isLiked = isLiked
    }

    func height(for width: CGFloat) -> CGFloat {
      48
    }
  }

  private(set) lazy var likeButton = ServiceButton(style: .init())
  private(set) lazy var shareButton = ServiceButton(style: .init())

  func setContent(_ content: Content, animated: Bool) {
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium, scale: .default)

    likeButton.setTitle("Save", for: [])
    likeButton.setImage(UIImage(systemName: "heart", withConfiguration: imageConfig), for: .normal)
    likeButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: imageConfig), for: .selected)
    likeButton.addTarget(self, action: #selector(didTapLikeButton(_:)), for: .touchUpInside)
    likeButton.isSelected = content.isLiked
    hStack.addArrangedSubview(likeButton)

//    shareButton.setContent(.init(titleText: "Share", image: UIImage(systemName: "square.and.arrow.up", withConfiguration: imageConfig)), animated: false)
//    shareButton.addTarget(self, action: #selector(didTapShareButton(_:)), for: .touchUpInside)
//    hStack.addArrangedSubview(shareButton)
  }

  // MARK: Private

  private var didTapLike: ((UIButton) -> Void)?

  private let hStack = UIStackView()

  private let style: Style

  @objc
  private func didTapLikeButton(_ button: UIButton) {
    button.isSelected = !button.isSelected
    didTapLike?(button)
  }

  @objc
  private func didTapShareButton(_ button: UIButton) {

  }
}

// MARK: - ServiceButton

final class ServiceButton: UIButton, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    directionalLayoutMargins = .zero
    backgroundColor = .option
    layer.cornerRadius = 12
    clipsToBounds = true

    titleLabel?.font = Font.medium(16)
    setTitleColor(.dark, for: [])
    tintColor = .accent

    setInsets(forContentPadding: .init(top: 0, left: 12, bottom: 0, right: 12), imageTitlePadding: 4)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  struct Style: Hashable {

  }

  struct Content: Equatable {
    let titleText: String?
    let image: UIImage?

    init(titleText: String?, image: UIImage?) {
      self.titleText = titleText
      self.image = image
    }
  }

  func setContent(_ content: Content, animated: Bool) {
    setTitle(content.titleText, for: [])
    setImage(content.image, for: [])
  }
}
