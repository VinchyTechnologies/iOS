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

    let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
    longPressedGesture.minimumPressDuration = 0.45
    longPressedGesture.delegate = self
    addGestureRecognizer(longPressedGesture)
  }
  required init?(coder: NSCoder) { fatalError() }

  // MARK: Internal

  struct Style: Hashable {

  }
  struct Behaviors {
    var didTapShareContextMenu: ((_ wineID: Int64) -> Void)?
    var didTapLeaveReviewContextMenu: ((_ wineID: Int64) -> Void)?
    var didTapWriteNoteContextMenu: ((_ wineID: Int64) -> Void)?
  }
  // MARK: ContentConfigurableView

  typealias Content = WineCollectionViewCellViewModel

  func setBehaviors(_ behaviors: Behaviors?) {
    didTapShareContextMenu = behaviors!.didTapShareContextMenu
    didTapWriteNoteContextMenu = behaviors?.didTapWriteNoteContextMenu
    didTapLeaveReviewContextMenu = behaviors?.didTapLeaveReviewContextMenu
  }

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
  }

  // MARK: Private

  private var didTapWriteNoteContextMenu: ((_ wineID: Int64) -> Void)?
  private var didTapLeaveReviewContextMenu: ((_ wineID: Int64) -> Void)?
  private var didTapShareContextMenu: ((_ wineID: Int64) -> Void)?

  private lazy var hapticGenerator = UISelectionFeedbackGenerator()

  private var wineID: Int64?

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
    let writeNote = ContextMenuItemWithImage(title: localized("write_note").firstLetterUppercased(), image: UIImage(systemName: "square.and.pencil")) { [weak self] in
      guard let wineID = self?.wineID else { return }
      self?.didTapWriteNoteContextMenu?(wineID)
    }
    let leaveReview = ContextMenuItemWithImage(title: localized("write_review").firstLetterUppercased(), image: UIImage(systemName: "text.bubble")) { [weak self] in
      guard let wineID = self?.wineID else { return }
      self?.didTapLeaveReviewContextMenu?(wineID)
    }

    let share = ContextMenuItemWithImage(title: localized("share_link").firstLetterUppercased(), image: UIImage(systemName: "square.and.arrow.up")) { [weak self] in
      guard let wineID = self?.wineID else { return }
      self?.didTapShareContextMenu?(wineID)
    }

    CM.items = [writeNote, leaveReview, share]
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
