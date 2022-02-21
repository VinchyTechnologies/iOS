//
//  OrderDateStatusView.swift
//  VinchyOrder
//
//  Created by Алексей Смирнов on 21.02.2022.
//

import DisplayMini
import EpoxyCore
import EpoxyLayoutGroups
import UIKit

final class OrderDateStatusView: UIView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    super.init(frame: .zero)
    backgroundColor = .clear
    translatesAutoresizingMaskIntoConstraints = false
    directionalLayoutMargins = .zero

    hGroup.install(in: self)
    hGroup.constrainToMarginsWithHighPriorityBottom()
//    hGroup.heightAnchor.constraint(equalToConstant: 64).isActive = true
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  struct Style: Hashable {

  }

  struct Content: Equatable {
    let dateText: String?
    let statusText: String?
    let statusColor: UIColor

    func height(width: CGFloat) -> CGFloat {
      let dateText = dateText ?? ""
      let statusText = statusText ?? ""
      let dateHeight = Label.height(for: dateText, width: width, style: .style(with: .subtitle))
      let statusHeight = Label.height(for: statusText, width: width, style: .style(with: .miniBold))
      return max(dateHeight, statusHeight)
    }
  }

  enum DataID {
    case first, date, price, firstSpacer, second, secondSpacer, orderNumber, status, tspacer, bspacer
  }

  func setContent(_ content: Content, animated: Bool) {
    hGroup.setItems {
      Label.groupItem(dataID: DataID.date, content: content.dateText ?? "", style: .style(with: .subtitle))
      SpacerItem(dataID: DataID.firstSpacer)
      Label.groupItem(dataID: DataID.status, content: content.statusText ?? "", style: .style(with: .miniBold))
        .textColor(content.statusColor)
    }
  }

  // MARK: Private

  private let hGroup = HGroup(alignment: .fill, accessibilityAlignment: .fill, spacing: 8, items: [])

}
