//
//  OrderItemView.swift
//  VinchyOrder
//
//  Created by Алексей Смирнов on 21.02.2022.
//

import DisplayMini
import EpoxyCollectionView
import EpoxyCore
import EpoxyLayoutGroups

// MARK: - OrderItemView

public final class OrderItemView: UIView, EpoxyableView {

  // MARK: Lifecycle

  public init(style: Style) {
    self.style = style
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    directionalLayoutMargins = .insets
    vGroup.install(in: self)
    vGroup.constrainToMarginsWithHighPriorityBottom()
  }

  required init?(coder: NSCoder) { fatalError() }

  // MARK: Public

  public struct Style: Hashable {

    public init(id: UUID) {
      self.id = id
    }

    let id: UUID
  }

  // MARK: ContentConfigurableView

  public struct Content: Equatable, Hashable {

    // MARK: Lifecycle

    public init(
      imageURL: URL?,
      titleText: String?,
      subtitleText: String?,
      leadingPriceText: String?,
      trailingPriceText: String?)
    {
      self.imageURL = imageURL
      self.titleText = titleText
      self.subtitleText = subtitleText
      self.leadingPriceText = leadingPriceText
      self.trailingPriceText = trailingPriceText
    }

    // MARK: Public

    public let imageURL: URL?
    public let titleText: String?
    public let subtitleText: String?
    public let leadingPriceText: String?
    public let trailingPriceText: String?

    public func height(width: CGFloat, style: Style) -> CGFloat {
      var result: CGFloat = .zero
      let topAndBottomPadding = NSDirectionalEdgeInsets.insets.top + NSDirectionalEdgeInsets.insets.bottom
      result += topAndBottomPadding

      let width = width - NSDirectionalEdgeInsets.insets.leading - NSDirectionalEdgeInsets.insets.trailing - .bottleWidth - .hSpacing

      if let subtitleText = subtitleText {
        result += subtitleText.height(forWidth: width, font: Font.medium(18), numberOfLines: 0)
      }

      if let titleText = titleText {
        result += .vSpacing
        result += titleText.height(forWidth: width, font: Font.heavy(20), numberOfLines: 0)
      }

      var leadingHeight: CGFloat = 0
      var trailingHeight: CGFloat = 0

      if let leadingPriceText = leadingPriceText {
        leadingHeight = Label.height(for: leadingPriceText, width: width, style: .style(with: .regular))
      }
      if let trailingPriceText = trailingPriceText {
        trailingHeight = Label.height(for: trailingPriceText, width: width, style: .style(with: .miniBold))
      }

      if (leadingHeight + trailingHeight) != 0 {
        result += .vSpacing + 4
        result += max(leadingHeight, trailingHeight)
      }

      return max(result, .bottleHeight + topAndBottomPadding)
    }
  }

  public func setContent(_ content: Content, animated: Bool) {

    vGroup.setItems {
      HGroupItem.init(
        dataID: DataID.hGroup,
        style: .init(alignment: .center, accessibilityAlignment: .center, spacing: .hSpacing, reflowsForAccessibilityTypeSizes: false, forceVerticalAccessibilityLayout: false)) {
          if let bottleURL = content.imageURL {
            IconView.groupItem(
              dataID: DataID.bottle,
              content: .init(image: .bottle(url: bottleURL.absoluteString)),
              style: .init(size: .init(width: .bottleWidth, height: .bottleHeight)))
          }

          VGroupItem.init(dataID: DataID.vGroup, style: .init(alignment: .leading, spacing: .vSpacing)) {

            if let subtitleText = content.subtitleText {
              Label.groupItem(
                dataID: DataID.subtitle,
                content: subtitleText,
                style: .style(with: .subtitle))
            }

            if let titleText = content.titleText {
              Label.groupItem(
                dataID: DataID.title,
                content: titleText,
                style: .style(with: .lagerTitle))
            }

            if content.leadingPriceText != nil || content.trailingPriceText != nil {
              SpacerItem(dataID: DataID.stepperView, style: .init(minHeight: 4))
            }

            HGroupItem.init(dataID: DataID.stepper, style: .init(alignment: .center, accessibilityAlignment: .center, reflowsForAccessibilityTypeSizes: false, forceVerticalAccessibilityLayout: false)) {

              if let leadingPriceText = content.leadingPriceText {
                Label.groupItem(
                  dataID: DataID.subtitle,
                  content: leadingPriceText,
                  style: .style(with: .regular))
              }
              if let trailingPriceText = content.trailingPriceText {
                SpacerItem(dataID: DataID.spacerStepper, style: .init(minWidth: 10))
                Label.groupItem(
                  dataID: DataID.stepper,
                  content: trailingPriceText,
                  style: .style(with: .regular))
              }
            }
          }
      }
    }
  }

  // MARK: Private

  private enum DataID {
    case bottle, vGroup, stepper, title, subtitle, price, vSpacer, priceVGroup, oldPrice, badge, rating, hGroup, spacerStepper, stepperView
  }

  private let style: Style
  private var wineID: Int64?

  private let vGroup = VGroup(
    style: .init(
      alignment: .leading,
      spacing: .vSpacing),
    items: [])
}

extension CGFloat {
  fileprivate static let bottleHeight: CGFloat = 100
  fileprivate static let hSpacing: CGFloat = 12
  fileprivate static let bottleWidth: Self = 40
  fileprivate static let vSpacing: Self = 4
  fileprivate static let spacerHeight: Self = 2
  fileprivate static let buttonHeight: Self = 30
}

extension NSDirectionalEdgeInsets {
  fileprivate static let insets: Self = .init(top: 12, leading: 24, bottom: 12, trailing: 24)
}
