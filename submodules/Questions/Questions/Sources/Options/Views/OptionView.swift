//
//  OptionView.swift
//  Questions
//
//  Created by Алексей Смирнов on 12.03.2022.
//

import DisplayMini
import EpoxyCollectionView
import EpoxyCore
import EpoxyLayoutGroups

// MARK: - C

fileprivate enum C {
  static let vSpacing: CGFloat = 2
  static let hSpacing: CGFloat = 12
  static func iconBackgroundColor(isSelected: Bool) -> UIColor { isSelected ? .accent : .white }
  static func iconBorderColor(isSelected: Bool) -> UIColor? { isSelected ? nil : .lightGray }
  static func iconBorderWidth(isSelected: Bool) -> CGFloat { isSelected ? 0 : 1 }
}

// MARK: - OptionView

final class OptionView: UIView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    super.init(frame: .zero)
    directionalLayoutMargins = .init(top: 12, leading: 12, bottom: 12, trailing: 12)
    translatesAutoresizingMaskIntoConstraints = false
    hGroup.install(in: self)
    hGroup.constrainToMarginsWithHighPriorityBottom()
    backgroundColor = .option

    layer.cornerRadius = 12
    clipsToBounds = true
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  struct Style: Hashable {
  }

  struct Content: Equatable {
    let id: Int
    let titleText: String
    let isSelected: Bool

    func height(for width: CGFloat) -> CGFloat {
      let width: CGFloat = width - 24 - 22 - C.hSpacing
      let height = Label.height(for: titleText, width: width, style: .style(with: .regular)) + 24
      return max(48, height)
    }
  }

  func setContent(_ content: Content, animated: Bool) {
    hGroup.setItems {

      Label.groupItem(
        dataID: DataID.title,
        content: content.titleText,
        style: .style(with: .regular))
        .textColor(.dark)
        .backgroundColor(.clear)

      GroupItem<UIImageView>(
        dataID: DataID.image,
        content: content.isSelected,
        make: {
          let view = UIImageView()
          // this is required by LayoutGroups to ensure AutoLayout works as expected
          view.translatesAutoresizingMaskIntoConstraints = false
          view.widthAnchor.constraint(equalToConstant: 22).isActive = true
          view.heightAnchor.constraint(equalToConstant: 22).isActive = true
          return view
        },
        setContent: { context, content in
          context.constrainable.image = UIImage(named: "checkmark")?.withRenderingMode(.alwaysTemplate)
          context.constrainable.tintColor = .white
          context.constrainable.contentMode = .scaleAspectFit
          context.constrainable.layer.cornerRadius = 11
          context.constrainable.layer.borderWidth = 1
          context.constrainable.layer.borderColor = UIColor.lightGray.cgColor

          context.constrainable.backgroundColor = C.iconBackgroundColor(isSelected: content)
          context.constrainable.layer.borderColor = C.iconBorderColor(isSelected: content)?.cgColor
          context.constrainable.layer.borderWidth = C.iconBorderWidth(isSelected: content)
        })
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

  private let hGroup = HGroup(style: .init(alignment: .center, accessibilityAlignment: .center, spacing: C.hSpacing, reflowsForAccessibilityTypeSizes: false, forceVerticalAccessibilityLayout: false), items: [])

}

// MARK: HighlightableView

extension OptionView: HighlightableView {
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
