//
//  TextRow.swift
//  Smart
//
//  Created by Алексей Смирнов on 04.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Epoxy
import UIKit

// MARK: - TextRow

final class TextRow: UIView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    self.style = style
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    layoutMargins = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
    group.install(in: self)
    group.constrainToMarginsWithHighPriorityBottom()
  }

  required init?(coder aDecoder: NSCoder) { fatalError() }

  // MARK: Internal

  enum Style {
    case small, large
  }

  struct Content: Equatable {
    var id: Int
    var title: String?
    var body: String?
  }

  func setContent(_ content: Content, animated: Bool) {
    let titleStyle: UIFont.TextStyle
    let bodyStyle: UIFont.TextStyle

    switch style {
    case .large:
      titleStyle = .headline
      bodyStyle = .body

    case .small:
      titleStyle = .body
      bodyStyle = .caption1
    }

    group.setItems {
      VGroupItem.init(
        dataID: DataID.vGroupItem,
        style: .init(spacing: 8))
      {
        if let title = content.title {
          Label.groupItem(
            dataID: DataID.title,
            content: title,
            style: .style(with: titleStyle))
            .adjustsFontForContentSizeCategory(true)
            .textColor(UIColor.label)
        }

        if let body = content.body {
          Label.groupItem(
            dataID: DataID.body,
            content: body,
            style: .style(with: bodyStyle))
            .adjustsFontForContentSizeCategory(true)
            .numberOfLines(0)
            .textColor(UIColor.secondaryLabel)
        }
      }

      IconView.groupItem(
        dataID: DataID.image,
        content: UIImage(systemName: "arrow.up.right.square"),
        style: .init(size: .init(width: 24, height: 24), tintColor: .accent))
    }
  }

  // MARK: Private

  private enum DataID {
    case title
    case body
    case vGroupItem
    case image
  }

  private let style: Style
  private let group = HGroup(alignment: .center, spacing: 8)
}

// MARK: SelectableView

extension TextRow: SelectableView {
  func didSelect() {
    UISelectionFeedbackGenerator().selectionChanged()
  }
}

// MARK: HighlightableView

extension TextRow: HighlightableView {
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
