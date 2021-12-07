//
//  BottomPriceBarView.swift
//  Display
//
//  Created by Алексей Смирнов on 07.12.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import EpoxyCore
import EpoxyLayoutGroups

// MARK: - BottomPriceBar

public final class BottomPriceBarView: UIView, EpoxyableView {

  // MARK: Lifecycle

  public init(style: Style) {
    super.init(frame: .zero)
    backgroundColor = .clear
    translatesAutoresizingMaskIntoConstraints = false
    directionalLayoutMargins = .init(top: 12, leading: 24, bottom: 0, trailing: 24)
    
    hGroup.install(in: self)
    hGroup.constrainToMarginsWithHighPriorityBottom()
    hGroup.heightAnchor.constraint(equalToConstant: 56).isActive = true
  }
  
  private lazy var blurEffectView = UIVisualEffectView()

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Public

  public struct Style: Hashable {
    public init() {
    }
  }
  
  public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    let blurEffect = UIBlurEffect(style: traitCollection.userInterfaceStyle == .dark ? .dark : .light)
    blurEffectView.effect = blurEffect
  }

  public struct Behaviors {
    var didSelect: ((Int) -> Void)?

    public init(didSelect: ((Int) -> Void)?) {
      self.didSelect = didSelect
    }
  }

  public struct Content: Equatable {
    public let leadingText: String?
    public let trailingButtonText: String?
    
    public init(leadingText: String?, trailingButtonText: String?) {
      self.leadingText = leadingText
      self.trailingButtonText = trailingButtonText
    }
  }

  public func setBehaviors(_ behaviors: Behaviors?) {
    didSelect = behaviors?.didSelect
  }

  public func setContent(_ content: Content, animated: Bool) {
    addSubview(blurEffectView)
    let blurEffect = UIBlurEffect(style: traitCollection.userInterfaceStyle == .dark ? .dark : .light)
    blurEffectView.effect = blurEffect
    blurEffectView.translatesAutoresizingMaskIntoConstraints = false
    blurEffectView.constrainToSuperview()
    
    hGroup.setItems {
      if let subtitle = content.leadingText {
        Label.groupItem(
          dataID: DataID.leadingTitle,
          content: subtitle,
          style: Label.Style(font: Font.bold(18), showLabelBackground: false, numberOfLines: 1, textColor: .dark))
      }
      
      if let trailingButtonText = content.trailingButtonText {
        SpacerItem(dataID: DataID.spacer)
        priceButton(text: trailingButtonText)
      }
    }
  }
  
  private func priceButton(text: String?) -> GroupItemModeling {
    GroupItem<Button>(
      dataID: DataID.trailingButton,
      content: "",
      make: {
        let button = Button()
        // this is required by LayoutGroups to ensure AutoLayout works as expected
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        return button
      },
      setContent: { context, _ in
        let text = "~" + (text ?? "0.00")
        context.constrainable.setTitle(text, for: [])
        context.constrainable.titleLabel?.font = Font.with(size: 20, design: .round, traits: .bold)
        context.constrainable.setTitleColor(.white, for: [])
        context.constrainable.contentEdgeInsets = .init(top: 0, left: 18, bottom: 0, right: 18)
      })
      .setBehaviors { [weak self] context in
        guard let self = self else { return }
        context.constrainable.addTarget(self, action: #selector(self.didTapButton(_:)), for: .touchUpInside)
      }
  }
  
  @objc
  private func didTapButton(_ button: UIButton) {
  }
  
  private enum DataID {
    case leadingTitle
    case trailingButton
    case spacer
  }
  
  private let hGroup = HGroup(
    style: .init(
      alignment: .center,
      accessibilityAlignment: .center,
      spacing: 8,
      reflowsForAccessibilityTypeSizes: false,
      forceVerticalAccessibilityLayout: false),
    items: [])

  // MARK: Private

  private var didSelect: ((Int) -> Void)?

}
