//
//  CartItemView.swift
//  VinchyCart
//
//  Created by Алексей Смирнов on 15.02.2022.
//

import DisplayMini
import EpoxyCollectionView
import EpoxyCore
import EpoxyLayoutGroups

// MARK: - CartItemView

public final class CartItemView: UIView, EpoxyableView {

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

  public struct Behaviors {
    public let didTap: (UIButton, Int64) -> Void
    public init(didTap: @escaping ((UIButton, Int64) -> Void)) {
      self.didTap = didTap
    }
  }

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
      wineID: Int64,
      imageURL: URL?,
      titleText: String?,
      subtitleText: String?,
      priceText: String?,
      value: Int)
    {
      self.wineID = wineID
      self.imageURL = imageURL
      self.titleText = titleText
      self.subtitleText = subtitleText
      self.priceText = priceText
      self.value = value
    }

    // MARK: Public

    public let wineID: Int64
    public let imageURL: URL?
    public let titleText: String?
    public let subtitleText: String?
    public let priceText: String?
    public let value: Int

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

      result += 40 + .vSpacing

      return max(result, .bottleHeight + topAndBottomPadding)
    }
  }

  public func setBehaviors(_ behaviors: Behaviors?) {
    didTap = behaviors?.didTap
  }

  public func setContent(_ content: Content, animated: Bool) {

    wineID = content.wineID

    vGroup.setItems {
      HGroupItem.init(dataID: DataID.hGroup, style: .init(alignment: .center, accessibilityAlignment: .center, spacing: .hSpacing, reflowsForAccessibilityTypeSizes: false, forceVerticalAccessibilityLayout: false)) {
        if let bottleURL = content.imageURL {
          IconView.groupItem(
            dataID: DataID.bottle,
            content: .init(image: .bottle(url: bottleURL.absoluteString)),
            style: .init(size: .init(width: .bottleWidth, height: .bottleHeight)))
        }

        VGroupItem.init(dataID: DataID.vGroup, style: .init(alignment: .leading, spacing: .vSpacing)) {

          if let subtitleText = content.subtitleText {
//            SpacerItem(dataID: UUID())
            Label.groupItem(
              dataID: DataID.subtitle,
              content: subtitleText,
              style: .style(with: .subtitle))
            //            .lineBreakMode(.byCharWrapping)
            //            .contentCompressionResistancePriority(.required, for: .horizontal)
          }

          if let titleText = content.titleText {
            Label.groupItem(
              dataID: DataID.title,
              content: titleText,
              style: .style(with: .lagerTitle))
            //            .lineBreakMode(.byCharWrapping)
            //            .contentCompressionResistancePriority(.required, for: .horizontal)
          }

          HGroupItem.init(dataID: DataID.stepper, style: .init(alignment: .center, accessibilityAlignment: .center, reflowsForAccessibilityTypeSizes: false, forceVerticalAccessibilityLayout: false)) {
            Label.groupItem(
              dataID: DataID.subtitle,
              content: content.priceText ?? "",
              style: .style(with: .miniBold))
            SpacerItem(dataID: DataID.spacerStepper, style: .init(minWidth: 10))
            StepperView.groupItem(dataID: DataID.stepperView, content: 1, behaviors: nil, style: .init())
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

  private var didTap: ((UIButton, Int64) -> Void)?

  private let vGroup = VGroup(
    style: .init(
      alignment: .leading,
      spacing: .vSpacing),
    items: [])

  @objc
  private func didTapButton(_ button: UIButton) {
    guard let wineID = wineID else {
      return
    }

    didTap?(button, wineID)
  }
}

// MARK: HighlightableView

extension CartItemView: HighlightableView {
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
