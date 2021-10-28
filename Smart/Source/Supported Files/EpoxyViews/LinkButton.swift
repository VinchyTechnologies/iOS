//
//  EpoxyButton.swift
//  Smart
//
//  Created by Алексей Смирнов on 27.10.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import Epoxy

final class LinkButton: UIButton, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    directionalLayoutMargins = .zero

    setTitleColor(.accent, for: [])
    titleLabel?.font = Font.medium(16)
    switch style.kind {
    case .normal:
      break

    case .arraw:
      let imageConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .semibold, scale: .default)
      setImage(
        UIImage(
          systemName: "chevron.right",
          withConfiguration: imageConfig),
        for: [])
      transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
      titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
      imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
      setInsets(forContentPadding: .zero, imageTitlePadding: .zero)

      tintColor = .accent
    }
    addTarget(
      self,
      action: #selector(handleButtonTapped(_:)),
      for: .touchUpInside)

    addTarget(
      self,
      action: #selector(didTouchCancelAction(_:)),
      for: [.touchDragExit, .touchDragOutside, .touchCancel, .touchUpOutside, .editingDidEnd])

    addTarget(
      self,
      action: #selector(didTouchDownAction(_:)),
      for: [.touchDown, .touchDragInside])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  struct Style: Hashable {
    enum Kind {
      case normal, arraw
    }

    let kind: Kind
  }

  struct Content: Equatable {
    let title: String?
  }

  struct Behaviors {
    let didTap: (UIButton) -> Void
  }

  func setContent(_ content: Content, animated: Bool) {
    setTitle(content.title, for: [])
  }

  func setBehaviors(_ behaviors: Behaviors?) {
    didTap = behaviors?.didTap
  }

  // MARK: Private

  private var didTap: ((UIButton) -> Void)?

  @objc
  private func handleButtonTapped(_ button: UIButton) {
    didTap?(button)
    alpha = 1.0
  }

  @objc
  private func didTouchDownAction(_ button: UIButton) {
    alpha = 0.2
  }

  @objc
  private func didTouchCancelAction(_ button: UIButton) {
    alpha = 1.0
  }

}
