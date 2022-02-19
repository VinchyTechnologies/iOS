//
//  HorizontalWineView.swift
//  Display
//
//  Created by Алексей Смирнов on 01.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import EpoxyCollectionView
import EpoxyCore
import EpoxyLayoutGroups

// MARK: - HorizontalWineView

public final class HorizontalWineView: UIView, EpoxyableView {

  // MARK: Lifecycle

  public init(style: Style) {
    self.style = style
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    directionalLayoutMargins = .insets
    hGroup.install(in: self)
    hGroup.constrainToMarginsWithHighPriorityBottom()
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

    public enum Kind: Hashable {
      case common
      case price
    }

    public init(id: UUID, kind: Kind) {
      self.id = id
      self.kind = kind
    }

    let id: UUID
    let kind: Kind
  }

  // MARK: ContentConfigurableView

  public struct Content: Equatable, Hashable {

    // MARK: Lifecycle

    public init(
      wineID: Int64,
      imageURL: URL?,
      titleText: String?,
      subtitleText: String?,
      buttonText: String?,
      oldPriceText: String?,
      badgeText: String?,
      rating: Double?)
    {
      self.wineID = wineID
      self.imageURL = imageURL
      self.titleText = titleText
      self.subtitleText = subtitleText
      self.buttonText = buttonText
      self.oldPriceText = oldPriceText
      self.badgeText = badgeText
      self.rating = rating
    }

    // MARK: Public

    public let wineID: Int64
    public let imageURL: URL?
    public let titleText: String?
    public let subtitleText: String?
    public let buttonText: String?
    public let oldPriceText: String?
    public let badgeText: String?
    public let rating: Double?

    public func height(width: CGFloat, style: Style) -> CGFloat {
      var result: CGFloat = .zero
      let topAndBottomPadding = NSDirectionalEdgeInsets.insets.top + NSDirectionalEdgeInsets.insets.bottom
      result += topAndBottomPadding

      var width = width - NSDirectionalEdgeInsets.insets.leading - NSDirectionalEdgeInsets.insets.trailing - .bottleWidth - .hSpacing

      var buttonWidth: CGFloat = 0.0
      var oldPriceTextWidth: CGFloat = 0.0
      var buttonsSpacing: CGFloat = 0
      if let buttonText = buttonText, style.kind == .price {
        buttonWidth += 24 + buttonText.width(usingFont: Font.with(size: 16, design: .round, traits: .bold))
        buttonsSpacing = .hSpacing
      }
      if let oldPriceText = oldPriceText, style.kind == .price {
        oldPriceTextWidth += oldPriceText.width(usingFont: Font.with(size: 14, design: .round, traits: .bold))
        buttonsSpacing = .hSpacing
      }

      width = width - buttonsSpacing - max(buttonWidth, oldPriceTextWidth)

      if let subtitleText = subtitleText {
        result += subtitleText.height(forWidth: width, font: Font.medium(18), numberOfLines: 0)
      }

      if let badgeText = badgeText {
        result += badgeText.height(forWidth: width, font: Font.with(size: 12, design: .round, traits: .bold)) + 3 + 3
        result += .spacerHeight
      }

      if let titleText = titleText {
        result += .vSpacing
        result += titleText.height(forWidth: width, font: Font.heavy(20), numberOfLines: 0)
      }

      if let rating = rating, rating != 0.0 {
        result += StarRatingControlView.height
      }

      return max(result, .bottleHeight + topAndBottomPadding)
    }
  }

  public func setBehaviors(_ behaviors: Behaviors?) {
    didTap = behaviors?.didTap
  }

  public func setContent(_ content: Content, animated: Bool) {

    wineID = content.wineID

    hGroup.setItems {
      if let bottleURL = content.imageURL {
        IconView.groupItem(
          dataID: DataID.bottle,
          content: .init(image: .bottle(url: bottleURL.absoluteString)),
          style: .init(size: .init(width: .bottleWidth, height: .bottleHeight)))
      }

      VGroupItem.init(dataID: DataID.vGroup, style: .init(alignment: .leading, spacing: .vSpacing)) {

        if let badgeText = content.badgeText {
          badge(text: badgeText)
          SpacerItem.init(dataID: DataID.vSpacer, style: .init(fixedHeight: .spacerHeight))
        }

        if let subtitleText = content.subtitleText {
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

        if let rating = content.rating, rating != 0.0 {
          StarRatingControlView.groupItem(
            dataID: DataID.rating,
            content: .init(rate: rating, count: 0),
            style: .init(kind: .small))
        }
      }

      if style.kind == .price {
        VGroupItem.init(dataID: DataID.priceVGroup, style: .init(alignment: .trailing, spacing: .vSpacing)) {
          if let oldPriceText = content.oldPriceText {
            oldPriceView(text: oldPriceText)
          }
          if let buttonText = content.buttonText {
            priceButton(text: buttonText)
          }
        }
      }
    }
  }

  // MARK: Private

  private enum DataID {
    case bottle, vGroup, title, subtitle, price, vSpacer, priceVGroup, oldPrice, badge, rating
  }


  private let style: Style

  private var wineID: Int64?

  private var didTap: ((UIButton, Int64) -> Void)?

  private let hGroup = HGroup(
    style: .init(
      alignment: .center,
      accessibilityAlignment: .center,
      spacing: .hSpacing,
      reflowsForAccessibilityTypeSizes: false,
      forceVerticalAccessibilityLayout: false),
    items: [])

  private func badge(text: String?) -> GroupItemModeling {
    GroupItem<Button>(
      dataID: DataID.price,
      content: "",
      make: {
        let button = Button()
        // this is required by LayoutGroups to ensure AutoLayout works as expected
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
      },
      setContent: { context, _ in
        context.constrainable.backgroundColor = .systemPurple
        context.constrainable.setTitle(text, for: [])
        context.constrainable.titleLabel?.font = Font.with(size: 12, design: .round, traits: .bold)
        context.constrainable.setTitleColor(.white, for: [])
        context.constrainable.contentEdgeInsets = .init(top: 3, left: 6, bottom: 3, right: 6)
      })
      .setBehaviors { [weak self] context in
        guard let self = self else { return }
        context.constrainable.addTarget(self, action: #selector(self.didTapButton(_:)), for: .touchUpInside)
      }
      .contentCompressionResistancePriority(.required, for: .horizontal)
  }

  private func priceButton(text: String?) -> GroupItemModeling {
    GroupItem<Button>(
      dataID: DataID.price,
      content: "",
      make: {
        let button = Button()
        // this is required by LayoutGroups to ensure AutoLayout works as expected
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: .buttonHeight).isActive = true
        return button
      },
      setContent: { context, _ in
        context.constrainable.setTitle(text, for: [])
        context.constrainable.titleLabel?.font = Font.with(size: 16, design: .round, traits: .bold)
        context.constrainable.setTitleColor(.white, for: [])
        context.constrainable.contentEdgeInsets = .init(top: 0, left: 12, bottom: 0, right: 12)
      })
      .setBehaviors { [weak self] context in
        guard let self = self else { return }
        context.constrainable.addTarget(self, action: #selector(self.didTapButton(_:)), for: .touchUpInside)
      }
      .contentCompressionResistancePriority(.required, for: .horizontal)
  }

  private func oldPriceView(text: String?) -> GroupItemModeling {
    GroupItem<UILabel>(
      dataID: DataID.oldPrice,
      content: "",
      make: {
        let label = UILabel()
        // this is required by LayoutGroups to ensure AutoLayout works as expected
        label.translatesAutoresizingMaskIntoConstraints = false
//        button.heightAnchor.constraint(equalToConstant: .buttonHeight).isActive = true
        return label
      },
      setContent: { context, _ in
        let attributeString = NSMutableAttributedString(string: text ?? "")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributeString.length))
        context.constrainable.font = Font.with(size: 14, design: .round, traits: .bold)
        context.constrainable.attributedText = attributeString
        context.constrainable.textColor = .blueGray
      })
      .contentCompressionResistancePriority(.required, for: .horizontal)
  }

  @objc
  private func didTapButton(_ button: UIButton) {
    guard let wineID = wineID else {
      return
    }

    didTap?(button, wineID)
  }
}

// MARK: HighlightableView

extension HorizontalWineView: HighlightableView {
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
