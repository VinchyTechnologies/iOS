//
//  HorizontalShopView.swift
//  Smart
//
//  Created by Михаил Исаченко on 09.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import AudioToolbox
import CoreHaptics
import DisplayMini
import EpoxyCollectionView
import EpoxyCore
import EpoxyLayoutGroups

// MARK: - Constants

private enum Constants {
  static let vibrationSoundId: SystemSoundID = 1519
}

// MARK: - HorizontalPartnerView

public final class HorizontalPartnerView: UIView, EpoxyableView {

  // MARK: Lifecycle

  public init(style: Style) {
    super.init(frame: .zero)
    backgroundColor = .option
    layer.cornerRadius = 24
    clipsToBounds = true
    directionalLayoutMargins = .init(top: 15, leading: 15, bottom: 15, trailing: 15)
    vGroup.install(in: self)
    vGroup.constrainToMarginsWithHighPriorityBottom()

    longPressedGesture.minimumPressDuration = 0.45
    addGestureRecognizer(longPressedGesture)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Public

  public struct Style: Hashable {
    public init() {

    }
  }
  // MARK: ContentConfigurableView

  public struct Content: Equatable {

    // MARK: Lifecycle

    public init(
      affiliatedStoreId: Int,
      imageURL: String?,
      titleText: String?,
      subtitleText: String?,
      widgetText: String?,
      contextMenuRows: [ContextMenuRow])
    {
      self.affiliatedStoreId = affiliatedStoreId
      self.imageURL = imageURL
      self.titleText = titleText
      self.subtitleText = subtitleText
      self.widgetText = widgetText
      self.contextMenuRows = contextMenuRows
    }

    // MARK: Public

    public enum ContextMenuRow: Equatable {
      case delete(titleText: String?)
    }

    public let affiliatedStoreId: Int
    public let imageURL: String?
    public let titleText: String?
    public let subtitleText: String?
    public let widgetText: String?
    public let contextMenuRows: [ContextMenuRow]

    public func height(for width: CGFloat) -> CGFloat {
      let width = width - 30
      var result: CGFloat = 30
      result += LogoRow.Content(title: titleText, logoURL: imageURL).height(for: width) + 8
      let storeMapRowHeight = StoreMapRow.Content(titleText: subtitleText, isMapButtonHidden: true).height(for: width)
      result += storeMapRowHeight + 8

      if widgetText?.isNilOrEmpty == false {
        result += Label.height(for: widgetText, width: width, style: .init(font: Font.medium(16), showLabelBackground: false)) + 8 // button vertical padding
      }

      return max(result, 80)
    }
  }

  public struct Behaviors {
    public let didTapContextMenuDeleteWidget: (() -> Void)?
    public init(didTapContextMenuDeleteWidget: (() -> Void)?) {
      self.didTapContextMenuDeleteWidget = didTapContextMenuDeleteWidget
    }
  }

  public func shake() {
    let shakeAnimation = CABasicAnimation(keyPath: "transform.rotation")
    shakeAnimation.duration = 0.05
    shakeAnimation.repeatCount = 2
    shakeAnimation.autoreverses = true
    let startAngle: Float = (-2) * .pi / 180
    let stopAngle = -startAngle
    shakeAnimation.fromValue = NSNumber(value: startAngle as Float)
    shakeAnimation.toValue = NSNumber(value: 1 * stopAngle as Float)
    shakeAnimation.duration = 0.17
    shakeAnimation.repeatCount = .infinity
    shakeAnimation.timeOffset = 290 * drand48()
    let layer: CALayer = self.layer
    layer.add(shakeAnimation, forKey:"shaking")
  }

  public func stopShaking() {
    let layer: CALayer = self.layer
    layer.removeAnimation(forKey: "shaking")
  }

  public func select() {
    layer.borderColor = UIColor.accent.cgColor
    layer.borderWidth = 2.0
  }

  public func deselect() {
    layer.borderColor = nil
    layer.borderWidth = 0.0
  }

  public func setContent(_ content: Content, animated: Bool) {
    contextMenuRows = content.contextMenuRows
    affilatedId = content.affiliatedStoreId
    longPressedGesture.isEnabled = !content.contextMenuRows.isEmpty

    vGroup.setItems {
      if let titleText = content.titleText {
        LogoRow.groupItem(
          dataID: DataID.logo,
          content: .init(title: titleText, logoURL: content.imageURL),
          style: .large)
      }

      if let subtitleText = content.subtitleText {
        StoreMapRow.groupItem(
          dataID: DataID.address,
          content: .init(titleText: subtitleText, isMapButtonHidden: true),
          style: .init())
      }

      if let widgetText = content.widgetText, !widgetText.isNilOrEmpty {
        LinkButton.groupItem(
          dataID: DataID.widgetText,
          content: .init(title: widgetText),
          behaviors: .init(didTap: { _ in

          }), style: .init(kind: .normal))
          .isEnabled(false)
      }
    }
  }

  public func setBehaviors(_ behaviors: Behaviors?) {
    didTapContextMenuDeleteWidget = behaviors?.didTapContextMenuDeleteWidget
  }

  // MARK: Private

  private enum DataID {
    case logo, address, widgetText
  }

  private var didTapContextMenuDeleteWidget: (() -> Void)?
  private lazy var longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))

  private var contextMenuRows: [Content.ContextMenuRow] = []
  private var affilatedId: Int?

  private var vGroup = VGroup(alignment: .leading, spacing: 8, items: [])

  @objc
  private func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
    if gestureRecognizer.state != .began {
      return
    }
    if CHHapticEngine.capabilitiesForHardware().supportsHaptics {
      HapticEffectHelper.vibrate(withEffect: .heavy)
    } else {
      AudioServicesPlaySystemSound(Constants.vibrationSoundId)
    }
    var contextMenuItems: [ContextMenuItemWithImage] = []
    contextMenuRows.forEach {
      switch $0 {
      case .delete(let content):
        guard let title = content else {
          return
        }
        contextMenuItems.append(.init(title: title, image: UIImage(systemName: "trash")){ [weak self] in
          guard let self = self else { return }
          self.didTapContextMenuDeleteWidget?()
        })
      }
    }
    CM.items = contextMenuItems
    CM.showMenu(viewTargeted: self, animated: true)
  }

}

// MARK: HighlightableView

extension HorizontalPartnerView: HighlightableView {
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
