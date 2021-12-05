//
//  StoreMapRow.swift
//  Smart
//
//  Created by Алексей Смирнов on 10.11.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import EpoxyCore
import EpoxyLayoutGroups
import UIKit

// MARK: - StoreMapRow

final class StoreMapRow: UIView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    self.style = style
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    layoutMargins = .zero
    group.install(in: self)
    group.constrainToMarginsWithHighPriorityBottom()
  }

  required init?(coder aDecoder: NSCoder) { fatalError() }

  // MARK: Public

  public struct Behaviors {
    var didTapMap: ((UIButton) -> Void)?

    public init(didTapMap: ((UIButton) -> Void)?) {
      self.didTapMap = didTapMap
    }
  }

  // MARK: Internal

  struct Style: Hashable {
  }

  struct Content: Equatable {
    var title: String?

    func height(for width: CGFloat) -> CGFloat {
      let widthOfImage: CGFloat = .imageSide + 8
      let widthWithOrWithoutImage: CGFloat = width - widthOfImage
      let labelHeight = Label.height(for: title, width: widthWithOrWithoutImage, style: .style(with: .regular))
      let height = max(CGFloat.imageSide, labelHeight)
      return height
    }
  }

  func setContent(_ content: Content, animated: Bool) {
    group.setItems {
      VGroupItem.init(
        dataID: DataID.vGroupItem,
        style: .init(spacing: 8))
      {
        if let title = content.title {
          Label.groupItem(
            dataID: DataID.title,
            content: title,
            style: .style(with: .regular, textColor: .blueGray))
        }
      }
      mapButton()
    }
  }

  func setBehaviors(_ behaviors: Behaviors?) {
    didTapMap = behaviors?.didTapMap
  }

  // MARK: Private

  private enum DataID {
    case title
    case vGroupItem
    case image
  }

  private var didTapMap: ((UIButton) -> Void)?
  private let style: Style
  private let group = HGroup(style: .init(alignment: .center, accessibilityAlignment: .leading, spacing: 8, reflowsForAccessibilityTypeSizes: false, forceVerticalAccessibilityLayout: false), items: [])

  private func mapButton() -> GroupItemModeling {

    GroupItem<UIButton>(
      dataID: DataID.image,
      content: "",
      make: {
        let button = UIButton(type: .system)
        // this is required by LayoutGroups to ensure AutoLayout works as expected
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: .imageSide).isActive = true
        button.heightAnchor.constraint(equalToConstant: .imageSide).isActive = true
        button.imageView?.contentMode = .scaleAspectFill
        return button
      },
      setContent: { context, _ in
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium, scale: .default)
        context.constrainable.setImage(UIImage(systemName: "map", withConfiguration: imageConfig), for: [])
        context.constrainable.tintColor = .accent
      })
      .setBehaviors { [weak self] context in
        guard let self = self else { return }
        context.constrainable.addTarget(self, action: #selector(self.didTapMapButton(_:)), for: .touchUpInside)
      }
  }

  @objc
  private func didTapMapButton(_ button: UIButton) {
    didTapMap?(button)
  }

}

extension CGFloat {
  fileprivate static let imageSide: Self = 24
}
