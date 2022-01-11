//
//  ReviewView.swift
//  Smart
//
//  Created by Алексей Смирнов on 08.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import DisplayMini
import EpoxyCollectionView
import EpoxyCore

// MARK: - ReviewViewContextMenuViewModel

public enum ReviewViewContextMenuViewModel {
  case translate(content: ContextMenuItemViewModel)
}

// MARK: - ReviewViewViewModel

public struct ReviewViewViewModel: ViewModelProtocol, Equatable {

  // MARK: Lifecycle

  public init(
    id: Int,
    userNameText: String?,
    dateText: String?,
    reviewText: String?,
    rate: Double?,
    contextMenuViewModels: [ReviewViewContextMenuViewModel]?)
  {
    self.id = id
    self.userNameText = userNameText
    self.dateText = dateText
    self.reviewText = reviewText
    self.rate = rate
    self.contextMenuViewModels = contextMenuViewModels
  }

  // MARK: Public

  public let id: Int

  public static func == (lhs: ReviewViewViewModel, rhs: ReviewViewViewModel) -> Bool {
    lhs.id == rhs.id
  }

  // MARK: Fileprivate

  fileprivate let userNameText: String?
  fileprivate let dateText: String?
  fileprivate let reviewText: String?
  fileprivate let rate: Double?
  fileprivate let contextMenuViewModels: [ReviewViewContextMenuViewModel]?
}

// MARK: - ReviewView

public final class ReviewView: UIView, EpoxyableView {

  // MARK: Lifecycle

  public init(style: Style) {
    self.style = style
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false

    backgroundColor = .option
    layer.cornerRadius = 20
    clipsToBounds = true

    addSubview(rateLabel)
    NSLayoutConstraint.activate([
      rateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 14),
      rateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
    ])

    addSubview(ratingView)
    NSLayoutConstraint.activate([
      ratingView.leadingAnchor.constraint(equalTo: rateLabel.trailingAnchor, constant: 6),
      ratingView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -14),
      ratingView.centerYAnchor.constraint(equalTo: rateLabel.centerYAnchor),
    ])

    addSubview(dateLabel)
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
      dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 14),
    ])

    addSubview(userLabel)
    userLabel.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      userLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
      userLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14),
    ])

    addSubview(textLabel)
    textLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      textLabel.topAnchor.constraint(equalTo: rateLabel.bottomAnchor, constant: 0),
      textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
      textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
      textLabel.bottomAnchor.constraint(lessThanOrEqualTo: userLabel.topAnchor, constant: 0),
    ])

    longPressedGesture.minimumPressDuration = 0.45
    addGestureRecognizer(longPressedGesture)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implpublic emented")
  }

  // MARK: Public

  public struct Style: Hashable {
  }


  public typealias Content = ReviewViewViewModel

  public struct Behaviors {
    public let didTapTranslate: ((String?) -> Void)?
    public init(didTapTranslate: @escaping ((String?) -> Void)) {
      self.didTapTranslate = didTapTranslate
    }
  }

  public func setContent(_ content: Content, animated: Bool) {
    ratingView.rating = content.rate ?? 0
    rateLabel.text = String(content.rate ?? 0)
    dateLabel.text = content.dateText
    textLabel.text = content.reviewText
    userLabel.text = content.userNameText
    reviewText = content.reviewText
    contextMenuViewModels = content.contextMenuViewModels
    if content.contextMenuViewModels?.isEmpty == true || content.contextMenuViewModels == nil {
      longPressedGesture.isEnabled = false
    } else {
      longPressedGesture.isEnabled = true
    }
  }

  public func setBehaviors(_ behaviors: Behaviors?) {
    didTapTranslate = behaviors?.didTapTranslate
  }

  // MARK: Private

  private var reviewText: String?
  private var didTapTranslate: ((String?) -> Void)?
  private lazy var longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))

  private var contextMenuViewModels: [ReviewViewContextMenuViewModel]?

  private let style: Style

  private let rateLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Font.with(size: 30, design: .round, traits: .bold)
    label.textColor = .dark
    return label
  }()

  private lazy var ratingView: StarsRatingView = {
    var view = StarsRatingView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.settings.filledColor = .accent
    view.settings.emptyBorderColor = .accent
    view.settings.filledBorderColor = .accent
    view.settings.starSize = 24
    view.settings.fillMode = .half
    view.settings.minTouchRating = 0
    view.settings.starMargin = 0
    view.isUserInteractionEnabled = false
    return view
  }()

  private let dateLabel: UILabel = {
    let label = UILabel()
    label.font = Font.regular(14)
    label.textColor = .blueGray
    return label
  }()

  private lazy var textLabel: UILabel = {
    $0.numberOfLines = 0
    $0.textColor = .dark
    $0.font = Font.regular(15)
    return $0
  }(UILabel())

  private let userLabel: UILabel = {
    let label = UILabel()
    label.font = Font.semibold(16)
    label.textColor = .dark
    return label
  }()

  @objc
  private func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
    if gestureRecognizer.state != .began {
      return
    }
    HapticEffectHelper.vibrate(withEffect: .heavy)
    var contextMenuItems: [ContextMenuItemWithImage] = []
    contextMenuViewModels?.forEach {
      switch $0 {
      case .translate(let content):
        guard let title = content.title else {
          return
        }
        contextMenuItems.append(.init(title: title, image: UIImage(named: "translate_24")) { [weak self] in
          guard let self = self else { return }
          self.didTapTranslate?(self.reviewText)
        })
      }
    }
    CM.items = contextMenuItems
    CM.showMenu(viewTargeted: self, animated: true)
  }
}

// MARK: HighlightableView

extension ReviewView: HighlightableView {
  public func didHighlight(_ isHighlighted: Bool) {
    UIView.animate(
      withDuration: 0.15,
      delay: 0,
      options: [.beginFromCurrentState, .allowUserInteraction])
    {
      self.transform = isHighlighted
        ? CGAffineTransform(scaleX: 0.95, y: 0.95)
        : .identity
    }
  }
}
