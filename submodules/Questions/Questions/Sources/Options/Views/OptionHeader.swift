//
//  OptionHeader.swift
//  Questions
//
//  Created by Алексей Смирнов on 12.03.2022.
//

import DisplayMini
import EpoxyCore
import EpoxyLayoutGroups

final class OptionHeader: UIView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    directionalLayoutMargins = .init(top: 0, leading: 24, bottom: 0, trailing: 24)
    vGroup.install(in: self)
    vGroup.constrainToMarginsWithHighPriorityBottom()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  struct Style: Hashable {

  }

  struct Content: Equatable {
    let titleText: String
    let subtitleText: String?

    func height(for width: CGFloat) -> CGFloat {
      let width = width - 48
      var height = Label.height(for: titleText, width: width, style: .style(with: .lagerTitle))
      if !(subtitleText?.isNilOrEmpty == true) {
        height += Label.height(for: subtitleText, width: width, style: .style(with: .regular))
        height += 8
      }
      return height
    }
  }

  func setContent(_ content: Content, animated: Bool) {
    vGroup.setItems {
      Label.groupItem(
        dataID: DataID.title,
        content: content.titleText,
        style: .style(with: .lagerTitle))

      if let subtitleText = content.subtitleText {
        Label.groupItem(
          dataID: DataID.subtitle,
          content: subtitleText,
          style: .style(with: .regular))
          .textColor(.blueGray)
      }
    }
  }

  // MARK: Private

  private enum DataID {
    case title
    case subtitle
    case vGroupItem
  }

  private var vGroup = VGroup(alignment: .leading, spacing: 8, items: [])
}
