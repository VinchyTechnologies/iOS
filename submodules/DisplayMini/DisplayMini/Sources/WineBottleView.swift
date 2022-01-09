//
//  WineBottleView.swift
//  Display
//
//  Created by Алексей Смирнов on 31.10.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import AudioToolbox
import CoreHaptics
import EpoxyCollectionView
import EpoxyCore
import StringFormatting
import UIKit

// MARK: - ContextMenuViewModel

public enum ContextMenuViewModel {
  case share(content: ContextMenuItemViewModel)
  case writeNote(content: ContextMenuItemViewModel)
}

// MARK: - ContextMenuItemViewModel

public struct ContextMenuItemViewModel {
  public let title: String?
  public init(title: String?) {
    self.title = title
  }
}

// MARK: - WineBottleViewDelegate

public protocol WineBottleViewDelegate: AnyObject {
  func didTapShareContextMenu(wineID: Int64, sourceView: UIView)
  func didTapWriteNoteContextMenu(wineID: Int64)
}

// MARK: - Constants

private enum Constants {
  static let vibrationSoundId: SystemSoundID = 1519
}

// MARK: - WineBottleView

public final class WineBottleView: UIView, EpoxyableView, UIGestureRecognizerDelegate {

  // MARK: Lifecycle

  public init(style: Style) {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false

    background.backgroundColor = .option
    background.layer.cornerRadius = 40

    addSubview(background)
    background.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      background.leadingAnchor.constraint(equalTo: leadingAnchor),
      background.trailingAnchor.constraint(equalTo: trailingAnchor),
      background.bottomAnchor.constraint(equalTo: bottomAnchor),
      background.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9),
    ])

    addSubview(bottleImageView)
    bottleImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      bottleImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      bottleImageView.topAnchor.constraint(equalTo: topAnchor),
      bottleImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 2 / 3, constant: style.kind == .normal ? 0 : -20),
      bottleImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1 / 4),
    ])

    background.addSubview(ratingView)
    ratingView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      ratingView.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 20),
      ratingView.topAnchor.constraint(equalTo: background.topAnchor, constant: 15),
      ratingView.widthAnchor.constraint(equalToConstant: 20),
      ratingView.heightAnchor.constraint(equalToConstant: 20),
    ])

    background.addSubview(ratingLabel)
    ratingLabel.translatesAutoresizingMaskIntoConstraints = false
    ratingLabel.centerXAnchor.constraint(equalTo: ratingView.centerXAnchor).isActive = true
    ratingLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 4).isActive = true

    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .equalSpacing
    stackView.alignment = .center

    stackView.addArrangedSubview(UIView())
    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(subtitleLabel)
    stackView.addArrangedSubview(UIView())
//    stackView.setCustomSpacing(2, after: subtitleLabel)
    stackView.addArrangedSubview(button)

    addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: bottleImageView.bottomAnchor, constant: 0),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
    ])

    longPressedGesture.minimumPressDuration = 0.45
    longPressedGesture.delegate = self
    addGestureRecognizer(longPressedGesture)
  }

  required init?(coder: NSCoder) { fatalError() }

  // MARK: Public

  public struct Style: Hashable {

    public enum Kind {
      case normal, price
    }
    let kind: Kind
    public init(kind: Kind) {
      self.kind = kind
    }
  }

  public struct Content: Equatable {

    // MARK: Lifecycle

    public init(wineID: Int64, imageURL: URL?, titleText: String?, subtitleText: String?, rating: Double?, buttonText: String?, contextMenuViewModels: [ContextMenuViewModel]?) {
      self.wineID = wineID
      self.imageURL = imageURL
      self.titleText = titleText
      self.subtitleText = subtitleText
      self.rating = rating
      self.buttonText = buttonText
      self.contextMenuViewModels = contextMenuViewModels
    }

    // MARK: Public

    public let contextMenuViewModels: [ContextMenuViewModel]?

    public let wineID: Int64
    public let titleText: String?
    public let imageURL: URL?
    public let subtitleText: String?
    public let rating: Double?
    public let buttonText: String?

    public static func == (lhs: Content, rhs: Content) -> Bool {
      lhs.wineID == rhs.wineID
    }
  }

  public weak var delegate: WineBottleViewDelegate?

  public func setContent(_ content: Content, animated: Bool) {
    bottleImageView.loadBottle(url: content.imageURL)

    if let title = content.titleText {
      titleLabel.isHidden = false
      titleLabel.text = title
    } else {
      titleLabel.isHidden = true
    }

    if let subtitle = content.subtitleText {
      subtitleLabel.isHidden = false
      subtitleLabel.text = subtitle
    } else {
      subtitleLabel.isHidden = true
    }

    wineID = content.wineID

    if content.contextMenuViewModels?.isEmpty == true || content.contextMenuViewModels == nil {
      longPressedGesture.isEnabled = false
    } else {
      longPressedGesture.isEnabled = true
    }

    contextMenuViewModels = content.contextMenuViewModels

    if content.rating == nil || content.rating == 0 {
      ratingView.isHidden = true
      ratingLabel.isHidden = true
    } else {
      ratingView.rating = (content.rating ?? 0) / 5
      ratingLabel.text = String(format: "%.1f", content.rating ?? 0)
      ratingView.isHidden = false
      ratingLabel.isHidden = false
    }

    if let buttonText = content.buttonText, !buttonText.isEmpty {
      button.setTitle(buttonText, for: [])
      button.isHidden = false
    } else {
      button.isHidden = true
    }
  }

  // MARK: Private

  private lazy var longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
  private lazy var hapticGenerator = UISelectionFeedbackGenerator()

  private var wineID: Int64?
  private var contextMenuViewModels: [ContextMenuViewModel]?

  private let background = UIView()

  private let bottleImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = Font.bold(16)
    label.numberOfLines = 2
    label.textAlignment = .center
    return label
  }()

  private let subtitleLabel: UILabel = {
    let label = UILabel()
    label.font = Font.medium(14)
    label.textColor = .blueGray
    label.textAlignment = .center
    return label
  }()

  private lazy var ratingView: StarsRatingView = {
    $0.settings.filledColor = .accent
    $0.settings.emptyBorderColor = .accent
    $0.settings.filledBorderColor = .accent
    $0.settings.starSize = 24
    $0.settings.fillMode = .precise
    $0.settings.minTouchRating = 0
    $0.settings.starMargin = 0
    $0.isUserInteractionEnabled = false
    $0.settings.totalStars = 1
    return $0
  }(StarsRatingView())

  private let ratingLabel: UILabel = {
    $0.font = Font.with(size: 14, design: .round, traits: .bold)
    $0.textColor = .dark
    $0.textAlignment = .center
    return $0
  }(UILabel())

  private lazy var button: Button = {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.heightAnchor.constraint(equalToConstant: 30).isActive = true
    $0.titleLabel?.font = Font.with(size: 16, design: .round, traits: .bold)
    $0.contentEdgeInsets = .init(top: 0, left: 12, bottom: 0, right: 12)
    return $0
  }(Button())

  @objc
  private func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
    if gestureRecognizer.state != .began {
      return
    }
    if CHHapticEngine.capabilitiesForHardware().supportsHaptics {
      HapticEffectHelper.vibrate(withEffect: .heavy)
    } else {
      AudioServicesPlaySystemSound(Constants.vibrationSoundId)
    }
    var contextMenuItems: [ContextMenuItemWithImage] = []
    contextMenuViewModels?.forEach {
      switch $0 {
      case .share(let content):
        guard let title = content.title else {
          return
        }
        contextMenuItems.append(.init(title: title, image: UIImage(systemName: "square.and.arrow.up")){ [weak self] in
          guard let self = self else { return }
          guard let wineID = self.wineID else { return }
          self.delegate?.didTapShareContextMenu(wineID: wineID, sourceView: self)
        })

      case .writeNote(let content):
        guard let title = content.title else {
          return
        }
        contextMenuItems.append(.init(title: title, image: UIImage(systemName: "square.and.pencil")){ [weak self] in
          guard let wineID = self?.wineID else { return }
          self?.delegate?.didTapWriteNoteContextMenu(wineID: wineID)
        })
      }
    }
    CM.items = contextMenuItems
    CM.showMenu(viewTargeted: self, animated: true)
  }
}

// MARK: HighlightableView

extension WineBottleView: HighlightableView {
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
