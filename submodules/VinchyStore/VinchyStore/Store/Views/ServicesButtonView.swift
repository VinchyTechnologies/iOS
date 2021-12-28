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
    group.install(in: self)
    group.constrainToSuperview()
  }

  required init?(coder aDecoder: NSCoder) { fatalError() }

  // MARK: Internal

  struct Style: Hashable {
    init() {

    }
  }

  struct Content: Equatable {

    init() {

    }

    func height(for width: CGFloat) -> CGFloat {
      48
    }
  }

  func setContent(_ content: Content, animated: Bool) {
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium, scale: .default)
    group.setItems {
      ServiceButton.groupItem(
        dataID: DataID.linkService,
        content: .init(titleText: "Link", image: UIImage(systemName: "link", withConfiguration: imageConfig)),
        style: .init())

      ServiceButton.groupItem(
        dataID: DataID.saveService,
        content: .init(titleText: "Save", image: UIImage(systemName: "heart", withConfiguration: imageConfig)),
        style: .init())

      ServiceButton.groupItem(
        dataID: DataID.shareService,
        content: .init(titleText: "Share", image: UIImage(systemName: "square.and.arrow.up", withConfiguration: imageConfig)),
        style: .init())
    }
  }

  // MARK: Private

  private enum DataID {
    case linkService
    case saveService
    case shareService
  }

  private let style: Style
  private let group = HGroup.init(style: .init(alignment: .fill, accessibilityAlignment: .leading, spacing: 8, reflowsForAccessibilityTypeSizes: false, forceVerticalAccessibilityLayout: false), items: [])
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
    contentEdgeInsets = .init(top: 0, left: 12, bottom: 0, right: 12)
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
