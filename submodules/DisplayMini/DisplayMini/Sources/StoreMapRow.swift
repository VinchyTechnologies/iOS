//
//  StoreMapRow.swift
//  Smart
//
//  Created by Алексей Смирнов on 10.11.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import EpoxyCore
import EpoxyLayoutGroups
import UIKit

// MARK: - StoreMapRow

public final class StoreMapRow: UIView, EpoxyableView {

  // MARK: Lifecycle

  public init(style: Style) {
    self.style = style
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    layoutMargins = .zero
    directionalLayoutMargins = .zero
    group.install(in: self)
    group.constrainToMarginsWithHighPriorityBottom()
  }

  required init?(coder aDecoder: NSCoder) { fatalError() }

  // MARK: Public

  public struct Behaviors {
    public var didTapMap: ((UIButton) -> Void)?

    public init(didTapMap: ((UIButton) -> Void)?) {
      self.didTapMap = didTapMap
    }
  }

  public struct Style: Hashable {
    public init() {

    }
  }

  public struct Content: Equatable {
    public var titleText: String?
    public var isMapButtonHidden: Bool

    public init(titleText: String?, isMapButtonHidden: Bool) {
      self.titleText = titleText
      self.isMapButtonHidden = isMapButtonHidden
    }

    public func height(for width: CGFloat) -> CGFloat {
      let widthOfImage: CGFloat = isMapButtonHidden ? 0 : .imageSide + 8
      let widthWithOrWithoutImage: CGFloat = width - widthOfImage
      let labelHeight = Label.height(for: titleText, width: widthWithOrWithoutImage, style: .style(with: .regular))
      let height = max(isMapButtonHidden ? 0 : CGFloat.imageSide, labelHeight)
      return height
    }
  }

  public func setContent(_ content: Content, animated: Bool) {
    group.setItems {
      VGroupItem.init(
        dataID: DataID.vGroupItem,
        style: .init(spacing: 8))
      {
        if let titleText = content.titleText {
          Label.groupItem(
            dataID: DataID.title,
            content: titleText,
            style: .style(with: .regular, backgroundColor: .clear, textColor: .blueGray))
        }
      }
      if !content.isMapButtonHidden {
        mapButton()
      }
    }
  }

  public func setBehaviors(_ behaviors: Behaviors?) {
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
