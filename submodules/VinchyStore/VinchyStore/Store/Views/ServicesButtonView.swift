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
    hStack.distribution = .fillProportionally
    hStack.spacing = 8
  }

  required init?(coder aDecoder: NSCoder) { fatalError() }

  // MARK: Public

  public struct Behaviors {
    public let didTapLike: (UIButton) -> Void
    public let didTapSubscribe: (UIButton) -> Void
    public let didTapMore: (UIButton) -> Void
    public init(didTapLike: @escaping ((UIButton) -> Void), didTapSubscribe: @escaping (UIButton) -> Void, didTapMore: @escaping (UIButton) -> Void) {
      self.didTapLike = didTapLike
      self.didTapSubscribe = didTapSubscribe
      self.didTapMore = didTapMore
    }
  }

  public func setBehaviors(_ behaviors: Behaviors?) {
    didTapLike = behaviors?.didTapLike
    didTapSubscribe = behaviors?.didTapSubscribe
    didTapMore = behaviors?.didTapMore
  }

  // MARK: Internal

  struct Style: Hashable {
    init() {

    }
  }
  struct Content: Equatable {

    let isLiked: Bool
    let saveButtonText: String?
    let savedButtonText: String?
    let subscribeText: String?
    let subscribedText: String?
    let isSubscribed: Bool

    init(isLiked: Bool, saveButtonText: String?, savedButtonText: String?, subscribeText: String?, subscribedText: String?, isSubscribed: Bool) {
      self.isLiked = isLiked
      self.saveButtonText = saveButtonText
      self.savedButtonText = savedButtonText
      self.subscribeText = subscribeText
      self.subscribedText = subscribedText
      self.isSubscribed = isSubscribed
    }

    func height(for width: CGFloat) -> CGFloat {
      48
    }
  }

  private(set) lazy var likeButton = ServiceButton(style: .init())
  private(set) lazy var moreButton = ServiceButton(style: .init())
  private(set) lazy var subscribeButton = ServiceButton(style: .init())

  func setContent(_ content: Content, animated: Bool) {
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium, scale: .default)

    likeButton.setTitle(content.saveButtonText, for: .normal)
    likeButton.setTitle(content.savedButtonText, for: .selected)
    likeButton.setImage(UIImage(systemName: "heart", withConfiguration: imageConfig), for: .normal)
    likeButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: imageConfig), for: .selected)
    likeButton.addTarget(self, action: #selector(didTapLikeButton(_:)), for: .touchUpInside)
    likeButton.isSelected = content.isLiked
    hStack.addArrangedSubview(likeButton)

    subscribeButton.setTitle(content.subscribeText, for: .normal)
    subscribeButton.setTitle(content.subscribedText, for: .selected)
    subscribeButton.setImage(UIImage(systemName: "bell", withConfiguration: imageConfig), for: .normal)
    subscribeButton.setImage(UIImage(systemName: "bell.fill", withConfiguration: imageConfig), for: .selected)
    subscribeButton.addTarget(self, action: #selector(didTapSubscribeButton(_:)), for: .touchUpInside)
    subscribeButton.isSelected = content.isSubscribed
    hStack.addArrangedSubview(subscribeButton)

    moreButton.translatesAutoresizingMaskIntoConstraints = false
    moreButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
    moreButton.setContent(.init(titleText: nil, image: UIImage(systemName: "ellipsis", withConfiguration: imageConfig)), animated: false)
    moreButton.addTarget(self, action: #selector(didTapMoreButton(_:)), for: .touchUpInside)
    hStack.addArrangedSubview(moreButton)
  }

  // MARK: Private

  private var didTapLike: ((UIButton) -> Void)?
  private var didTapSubscribe: ((UIButton) -> Void)?
  private var didTapMore: ((UIButton) -> Void)?

  private let hStack = UIStackView()

  private let style: Style

  @objc
  private func didTapLikeButton(_ button: UIButton) {
    button.isSelected = !button.isSelected
    didTapLike?(button)
  }

  @objc
  private func didTapSubscribeButton(_ button: UIButton) {
    didTapSubscribe?(button)
  }

  @objc
  private func didTapMoreButton(_ button: UIButton) {
    didTapMore?(button)
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

    titleLabel?.numberOfLines = 1
    titleLabel?.adjustsFontSizeToFitWidth = true
    titleLabel?.lineBreakMode = .byClipping
    titleLabel?.minimumScaleFactor = 0.5
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
    if !content.titleText.isNilOrEmpty {
      setInsets(forContentPadding: .init(top: 0, left: 12, bottom: 0, right: 12), imageTitlePadding: 4)
    } else {
      setInsets(forContentPadding: .init(top: 0, left: 12, bottom: 0, right: 12), imageTitlePadding: 0)
    }
    setTitle(content.titleText, for: [])
    setImage(content.image, for: [])
  }
}
