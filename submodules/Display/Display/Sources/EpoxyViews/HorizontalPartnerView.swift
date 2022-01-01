//
//  HorizontalShopView.swift
//  Smart
//
//  Created by Михаил Исаченко on 09.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import DisplayMini
import EpoxyCollectionView
import EpoxyCore
import EpoxyLayoutGroups

// MARK: - HorizontalPartnerView

public final class HorizontalPartnerView: UIView, EpoxyableView {

  // MARK: Lifecycle

  public init(style: Style) {
    super.init(frame: .zero)
    backgroundColor = .option
    layer.cornerRadius = 24
    clipsToBounds = true
    directionalLayoutMargins = .init(top: 15, leading: 15, bottom: 15, trailing: 15)
    vGroup.install(in: self)
    vGroup.constrainToMarginsWithHighPriorityBottom()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Public

  public struct Style: Hashable {
    public init() {

    }
  }

  // MARK: ContentConfigurableView

  public struct Content: Equatable {

    // MARK: Lifecycle

    public init(
      affiliatedStoreId: Int,
      imageURL: String?,
      titleText: String?,
      subtitleText: String?)
    {
      self.affiliatedStoreId = affiliatedStoreId
      self.imageURL = imageURL
      self.titleText = titleText
      self.subtitleText = subtitleText
    }

    // MARK: Public

    public let affiliatedStoreId: Int
    public let imageURL: String?
    public let titleText: String?
    public let subtitleText: String?

    public func height(for width: CGFloat) -> CGFloat {
      let width = width - 30
      var result: CGFloat = 0
      result += LogoRow.Content(title: titleText, logoURL: imageURL).height(for: width)
      let storeMapRowHeight = StoreMapRow.Content(titleText: subtitleText, isMapButtonHidden: true).height(for: width)
      result += storeMapRowHeight //+ 8 // ?????
      result += 15 + 15
      return max(result, 80)
    }
  }

  public func setContent(_ content: Content, animated: Bool) {
    vGroup.setItems {
      if let titleText = content.titleText {
        LogoRow.groupItem(
          dataID: DataID.logo,
          content: .init(title: titleText, logoURL: content.imageURL),
          style: .large)
      }

      if let subtitleText = content.subtitleText {
        StoreMapRow.groupItem(
          dataID: DataID.address,
          content: .init(titleText: subtitleText, isMapButtonHidden: true),
          style: .init())
      }
    }
  }

  // MARK: Private

  private enum DataID {
    case logo, address
  }

  private var vGroup = VGroup(alignment: .leading, spacing: 8, items: [])

}

// MARK: HighlightableView

extension HorizontalPartnerView: HighlightableView {
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
