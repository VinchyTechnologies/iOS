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

    public init(kind: Kind) {
      self.kind = kind
    }

    let kind: Kind
  }

  // MARK: ContentConfigurableView

  public struct Content: Equatable {

    // MARK: Lifecycle

    public init(
      wineID: Int64,
      imageURL: URL?,
      titleText: String?,
      subtitleText: String?,
      buttonText: String?)
    {
      self.wineID = wineID
      self.imageURL = imageURL
      self.titleText = titleText
      self.subtitleText = subtitleText
      self.buttonText = buttonText
    }

    // MARK: Public

    public let wineID: Int64
    public let imageURL: URL?
    public let titleText: String?
    public let subtitleText: String?
    public let buttonText: String?

    public func height(width: CGFloat) -> CGFloat {
      var result: CGFloat = .zero
      let topAndBottomPadding = NSDirectionalEdgeInsets.insets.top + NSDirectionalEdgeInsets.insets.bottom
      result += topAndBottomPadding

      let width = width - NSDirectionalEdgeInsets.insets.leading - NSDirectionalEdgeInsets.insets.trailing - .bottleWidth - .hSpacing - .bottleWidth

      if let subtitleText = subtitleText {
        result += .vSpacing
        result += subtitleText.height(forWidth: width, font: Font.medium(18), numberOfLines: 0)
      }

      if let titleText = titleText {
        result += .vSpacing
        result += titleText.height(forWidth: width, font: Font.heavy(20), numberOfLines: 0)
      }

      if buttonText != nil {
        result += .vSpacing
        result += .spacerHeight
        result += .buttonHeight
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

        if let subtitleText = content.subtitleText {
          Label.groupItem(
            dataID: DataID.subtitle,
            content: subtitleText,
            style: .style(with: .subtitle))
            .contentCompressionResistancePriority(.required, for: .horizontal)
        }

        if let titleText = content.titleText {
          Label.groupItem(
            dataID: DataID.title,
            content: titleText,
            style: .style(with: .lagerTitle))
            .contentCompressionResistancePriority(.required, for: .horizontal)
        }

        if let buttonText = content.buttonText {
          SpacerItem.init(dataID: DataID.vSpacer, style: .init(fixedHeight: .spacerHeight))
          priceButton(text: buttonText)
        }
      }
    }
  }

  // MARK: Private

  private enum DataID {
    case bottle, vGroup, title, subtitle, price, vSpacer
  }

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
  fileprivate static let spacerHeight: Self = 8
  fileprivate static let buttonHeight: Self = 30
}

extension NSDirectionalEdgeInsets {
  fileprivate static let insets: Self = .init(top: 12, leading: 24, bottom: 12, trailing: 24)
}
