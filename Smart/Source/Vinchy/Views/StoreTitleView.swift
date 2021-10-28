//
//  StoreTitleCollectionCell.swift
//  Smart
//
//  Created by Алексей Смирнов on 13.09.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import Epoxy

// MARK: - StoreTitleCollectionCellDelegate

protocol StoreTitleCollectionCellDelegate: AnyObject {
  func didTapSeeAllStore(affilatedId: Int)
}

// MARK: - StoreTitleViewViewModel

struct StoreTitleViewViewModel: Equatable {

  let affilatedId: Int?
  fileprivate let imageURL: String?
  fileprivate let titleText: String?
  fileprivate let subtitleText: String?
  fileprivate let moreText: String?

  init(
    affilatedId: Int?,
    imageURL: String?,
    titleText: String?,
    subtitleText: String?,
    moreText: String?)
  {
    self.affilatedId = affilatedId
    self.imageURL = imageURL
    self.titleText = titleText
    self.subtitleText = subtitleText
    self.moreText = moreText
  }
}

// MARK: - C

fileprivate enum C {
  static let subtitleFont = Font.medium(14)
  static let vSpacing: CGFloat = 2
  static let hSpacing: CGFloat = 12
}

// MARK: - StoreTitleView

final class StoreTitleView: UIView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    self.style = style
    super.init(frame: .zero)
    layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    hGroup.install(in: self)
    hGroup.constrainToMarginsWithHighPriorityBottom()
  }

  required init?(coder aDecoder: NSCoder) { fatalError() }

  // MARK: Internal

  struct Style: Hashable {
  }

  struct Content: Equatable {
    let affilatedId: Int
    var titleText: String?
    var logoURL: String?
    var subtitleText: String?
    var moreText: String?

    func height(for width: CGFloat) -> CGFloat {
      let width: CGFloat = width - (logoURL == nil ? 0 : 48 + C.hSpacing) - (moreText?.width(usingFont: Font.medium(16)) ?? 0) - C.hSpacing - 12
      var height = titleText?.height(forWidth: width, font: Font.heavy(20)) ?? 0

      if !subtitleText.isNilOrEmpty {
        let vSpace: CGFloat = C.vSpacing
        let subtitleHeight = subtitleText?.height(forWidth: width, font: C.subtitleFont) ?? 0
        height += vSpace + subtitleHeight
      }

      return max(48, height)
    }
  }

  weak var delegate: StoreTitleCollectionCellDelegate?

  func setContent(_ content: Content, animated: Bool) {
    hGroup.setItems {
      if let logoURL = content.logoURL {
        IconView.groupItem(
          dataID: DataID.image,
          content: .init(image: .remote(url: logoURL)),
          style: .init(size: .init(width: 48, height: 48), tintColor: .blueGray, isRounded: true))
      }

      VGroupItem.init(
        dataID: DataID.vGroupItem,
        style: .init(spacing: C.vSpacing))
      {
        if let title = content.titleText {
          Label.groupItem(
            dataID: DataID.title,
            content: title,
            style: .style(with: .lagerTitle))
        }

        if let subtitle = content.subtitleText {
          Label.groupItem(
            dataID: DataID.subtitle,
            content: subtitle,
            style: Label.Style(font: C.subtitleFont, showLabelBackground: true, textColor: .blueGray))
        }
      }

      if let moreText = content.moreText {
        HGroupItem(
          dataID: DataID.more,
          style: .init(alignment: .center, spacing: 0))
        {
          SpacerItem(dataID: DataID.spacer)
          LinkButton.groupItem(
            dataID: DataID.moreButton,
            content: .init(title: moreText),
            behaviors: .init(didTap: { [weak self] _ in
              self?.delegate?.didTapSeeAllStore(affilatedId: content.affilatedId)
            }),
            style: LinkButton.Style(kind: .arraw))
            .contentCompressionResistancePriority(.required, for: .horizontal)
        }
      }
    }
  }

  // MARK: Private

  private enum DataID {
    case title
    case subtitle
    case vGroupItem
    case image
    case spacer
    case moreButton
    case disclosureArrow
    case more
  }

  private let style: Style
  private let hGroup = HGroup(alignment: .center, spacing: C.hSpacing)

  private var disclosureIndicator: GroupItemModeling {
    IconView.groupItem(
      dataID: DataID.disclosureArrow,
      content: .init(image: .local(UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .semibold, scale: .default)))),
      style: .init(
        size: .init(width: 12, height: 16),
        tintColor: .accent))
      .contentMode(.center)
      .contentCompressionResistancePriority(.required, for: .horizontal)
  }
}
