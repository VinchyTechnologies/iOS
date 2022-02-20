//
//  OrderView.swift
//  VinchyOrder
//
//  Created by Алексей Смирнов on 20.02.2022.
//

import DisplayMini
import EpoxyCore
import EpoxyLayoutGroups
import UIKit

final class OrderView: UIView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    super.init(frame: .zero)
    backgroundColor = .clear
    translatesAutoresizingMaskIntoConstraints = false
    directionalLayoutMargins = .zero

    vGroup.install(in: self)
    vGroup.constrainToMarginsWithHighPriorityBottom()
    vGroup.heightAnchor.constraint(equalToConstant: 64).isActive = true
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  struct Style: Hashable {

  }

  struct Content: Equatable {
    let dateText: String?
    let orderNumberText: String?
    let priceText: String?
    let statusText: String?
    let statusColor: UIColor
  }

  enum DataID {
    case first, date, price, firstSpacer, second, secondSpacer, orderNumber, status, tspacer, bspacer
  }

  func setContent(_ content: Content, animated: Bool) {
    vGroup.setItems {
      SpacerItem(dataID: DataID.tspacer, style: .init(minHeight: 4))
      HGroupItem(dataID: DataID.first, style: .init(alignment: .fill, accessibilityAlignment: .fill, spacing: 8, reflowsForAccessibilityTypeSizes: false, forceVerticalAccessibilityLayout: false)) {
        Label.groupItem(dataID: DataID.date, content: content.dateText ?? "", style: .style(with: .subtitle))
        SpacerItem(dataID: DataID.firstSpacer)
        Label.groupItem(dataID: DataID.status, content: content.statusText ?? "", style: .style(with: .miniBold))
          .textColor(content.statusColor)
      }

      HGroupItem(dataID: DataID.second, style: .init(alignment: .fill, accessibilityAlignment: .fill, spacing: 8, reflowsForAccessibilityTypeSizes: false, forceVerticalAccessibilityLayout: false)) {
        Label.groupItem(dataID: DataID.orderNumber, content: content.orderNumberText ?? "", style: .style(with: .miniBold))
        SpacerItem(dataID: DataID.secondSpacer)
        Label.groupItem(dataID: DataID.price, content: content.priceText ?? "", style: .style(with: .lagerTitle))
      }
      SpacerItem(dataID: DataID.bspacer, style: .init(minHeight: 4))
    }
  }

  // MARK: Private

  private let vGroup = VGroup(
    style: .init(alignment: .fill, spacing: 4),
    items: [])
}
