//
//  WineRateTableCell.swift
//  Smart
//
//  Created by Алексей Смирнов on 06.11.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Database
import Display
import DisplayMini
import EpoxyCore
import EpoxyLayoutGroups
import UIKit
import WineDetail // TODO: - remove

// MARK: - WineRateTableCellDelegate

public protocol WineRateTableCellDelegate: AnyObject {
  func didTapMore(reviewID: Int)
}

// MARK: - WineRateTableCell

public final class WineRateTableCell: UITableViewCell, Reusable {

  // MARK: Lifecycle

  override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    selectionStyle = .none

    backgroundColor = .mainBackground
    contentView.addSubview(view)
    view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
      view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
      view.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 0),
      view.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: 0),
    ])

    view.setBehaviors(.init(didTapMore: { [weak self] reviewID in
      self?.delegate?.didTapMore(reviewID: reviewID)
    }))
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Public

  public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    backgroundColor = highlighted ? .option : .mainBackground
  }

  // MARK: Internal

  weak var delegate: WineRateTableCellDelegate?

  static func height(for content: WineRateView.Content, width: CGFloat) -> CGFloat {
    WineRateView.height(for: content, width: width)
  }

  // MARK: Private

  private let view = WineRateView(style: .init())
}

// MARK: Decoratable

extension WineRateTableCell: Decoratable {

  public typealias ViewModel = WineRateView.Content

  public func decorate(model: ViewModel) {
    view.setContent(model, animated: true)
  }
}

// MARK: - WineRateView

public final class WineRateView: UIView, EpoxyableView {

  // MARK: Lifecycle

  public init(style: Style) {
    self.style = style
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    directionalLayoutMargins = .init(top: 24, leading: 24, bottom: 24, trailing: 24)
    group.install(in: self)
    group.constrainToMargins()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Public

  public struct Style: Hashable {

  }

  public struct Content: Equatable, ViewModelProtocol {
    let wineID: Int64
    let reviewID: Int
    let bottleURL: String?
    let titleText: String?
    let reviewText: String?
    let readMoreText: String?
    let wineryText: String?
    let starValue: Double?
  }

  public enum DataID {
    case bottle, title, message, read, contentGroup, nameGroup, topSpacer, bottomSpacer, winery, star
  }

  public struct Behaviours {
    public var didTapMore: ((_ reviewID: Int) -> Void)?
  }

  public static var vSpacing: CGFloat {
    UIDevice.current.userInterfaceIdiom == .pad ? 8 : 6
  }

  public static func height(for content: Content, width: CGFloat) -> CGFloat {

    let width = width - 56 - 24 - 24 - 24
    var height: CGFloat = 0

    if let wineryText = content.wineryText {
      height += Label.height(for: wineryText, width: width, style: .style(with: .subtitle))
      height += vSpacing
    }

    if let titleText = content.titleText {
      height += Label.height(for: titleText, width: width, style: .style(with: .lagerTitle))
      height += vSpacing
    }

    height += StarRatingControlView.height
    height += vSpacing

    if let reviewText = content.reviewText {
      height += Label.height(for: reviewText, width: width, style: .style(with: .body), numberOfLines: 3)
      height += vSpacing
    }

    if let readMoreText = content.readMoreText {
      height += Label.height(for: readMoreText, width: width, style: .init(font: Font.medium(16), showLabelBackground: true))
      height += vSpacing
    }

    height -= vSpacing

    height += 24 + 24

    return max(150, height)
  }

  public func setContent(_ content: Content, animated: Bool) {
    reviewId = content.reviewID
    group.setItems {
      avatar(url: content.bottleURL)
      VGroupItem(
        dataID: DataID.contentGroup,
        style: .init(alignment: .leading, spacing: Self.vSpacing))
      {
        if let wineryText = content.wineryText {
          winery(wineryText)
        }

        if let titleText = content.titleText {
          name(titleText)
        }

        if let starValue = content.starValue {
          stars(starValue)
        }

        if let reviewText = content.reviewText {
          messagePreview(reviewText)
        }

        if let readMoreText = content.readMoreText, content.reviewText != nil {
          seenText(readMoreText)
        }
      }
    }
  }

  public func setBehaviors(_ behaviors: Behaviours) {
    didTapMore = behaviors.didTapMore
  }

  // MARK: Private

  private var reviewId: Int?
  private var didTapMore: ((_ reviewID: Int) -> Void)?
  private let group = HGroup(alignment: .center, spacing: 24)
  private let style: Style

  private func avatar(url: String?) -> GroupItemModeling {
    IconView.groupItem(
      dataID: DataID.bottle,
      content: .init(image: .bottle(url: url)),
      style: .init(size: .init(width: 56, height: 120)))
  }

  private func stars(_ value: Double) -> GroupItemModeling {
    StarRatingControlView.groupItem(
      dataID: DataID.star,
      content: .init(rate: value, count: 0),
      style: .init(kind: .small))
  }

  private func winery(_ wineryName: String) -> GroupItemModeling {
    Label.groupItem(
      dataID: DataID.winery,
      content: wineryName,
      style: .style(with: .subtitle, backgroundColor: .clear))
      .numberOfLines(0)
  }

  private func name(_ name: String) -> GroupItemModeling {
    Label.groupItem(
      dataID: DataID.title,
      content: name,
      style: .style(with: .lagerTitle, backgroundColor: .clear))
      .numberOfLines(0)
  }

  private func messagePreview(_ messagePreview: String) -> GroupItemModeling {
    Label.groupItem(
      dataID: DataID.message,
      content: messagePreview,
      style: .style(with: .body))
      .numberOfLines(3)
  }

  private func seenText(_ seenText: String) -> GroupItemModeling {
    LinkButton.groupItem(
      dataID: DataID.read,
      content: LinkButton.Content.init(title: seenText),
      behaviors: .init(didTap: { [weak self] _ in
        guard let reviewId = self?.reviewId else {
          return
        }
        self?.didTapMore?(reviewId)
      }),
      style: LinkButton.Style.init(kind: .normal))
  }
}
