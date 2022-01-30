//
//  LogoRow.swift
//  Smart
//
//  Created by Алексей Смирнов on 05.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import EpoxyCore
import EpoxyLayoutGroups
import UIKit

// MARK: - TextRow

public final class LogoRow: UIView, EpoxyableView {

  // MARK: Lifecycle

  public init(style: Style) {
    self.style = style
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    layoutMargins = .zero//UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    group.install(in: self)
    group.constrainToMarginsWithHighPriorityBottom()
  }

  required init?(coder aDecoder: NSCoder) { fatalError() }

  // MARK: Public

  public enum Style {
    case large
  }

  public struct Content: Equatable {
    public var title: String?
    public var logoURL: String?

    public init(title: String?, logoURL: String?) {
      self.title = title
      self.logoURL = logoURL
    }

    public func height(for width: CGFloat) -> CGFloat {
      let widthOfImage: CGFloat = logoURL == nil ? 0 : (48 + 8)
      let widthWithOrWithoutImage: CGFloat = width - widthOfImage
      let labelHeight = Label.height(for: title, width: widthWithOrWithoutImage, style: .style(with: .lagerTitle))
      let height = logoURL == nil ? labelHeight : max(60, labelHeight)
      return height
    }
  }

  public func setContent(_ content: Content, animated: Bool) {

    group.setItems {

      if let logoURL = content.logoURL {
        IconView.groupItem(
          dataID: DataID.image,
          content: .init(image: .remote(url: logoURL)),
          style: .init(size: .init(width: 48, height: 48), tintColor: .accent, isRounded: true))
      }

      VGroupItem.init(
        dataID: DataID.vGroupItem,
        style: .init(spacing: 8))
      {
        if let title = content.title {
          Label.groupItem(
            dataID: DataID.title,
            content: title,
            style: .style(with: .lagerTitle, backgroundColor: .clear))
        }
      }
    }
  }

  // MARK: Private

  private enum DataID {
    case title
    case vGroupItem
    case image
  }

  private let style: Style
  private let group = HGroup.init(style: .init(alignment: .center, accessibilityAlignment: .leading, spacing: 8, reflowsForAccessibilityTypeSizes: false, forceVerticalAccessibilityLayout: false), items: [])
}
