//
//  WineBottleView.swift
//  Smart
//
//  Created by Алексей Смирнов on 05.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import AudioToolbox
import CommonUI
import CoreHaptics
import Display
import Epoxy
import StringFormatting

// MARK: - WineBottleViewDelegate

protocol WineBottleViewDelegate: AnyObject {
  func didTapShareContextMenu(wineID: Int64, sourceView: UIView)
  func didTapWriteNoteContextMenu(wineID: Int64)
}

// MARK: - Constants

private enum Constants {
  static let vibrationSoundId: SystemSoundID = 1519
}

// MARK: - WineBottleView

final class WineBottleView: UIView, EpoxyableView, UIGestureRecognizerDelegate {

  // MARK: Lifecycle

  init(style: Style) {
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
      bottleImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 2 / 3),
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
    stackView.distribution = .equalCentering
    stackView.alignment = .center

    stackView.addArrangedSubview(UIView())
    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(subtitleLabel)
    stackView.addArrangedSubview(UIView())

    stackView.setCustomSpacing(2, after: titleLabel)

    addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: bottleImageView.bottomAnchor, constant: 0),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
    ])

    if UIDevice.current.userInterfaceIdiom == .phone {
      let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
      longPressedGesture.minimumPressDuration = 0.45
      longPressedGesture.delegate = self
      addGestureRecognizer(longPressedGesture)
    }
  }

  required init?(coder: NSCoder) { fatalError() }

  // MARK: Internal

  struct Style: Hashable {

  }

  typealias Content = WineCollectionViewCellViewModel

  weak var delegate: WineBottleViewDelegate?

  func setContent(_ content: Content, animated: Bool) {
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
  }

  // MARK: Private

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
  func didHighlight(_ isHighlighted: Bool) {
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
