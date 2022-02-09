//
//  ServingTipsCollectionView.swift
//  Smart
//
//  Created by Алексей Смирнов on 10.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import EpoxyCollectionView
import EpoxyCore
import Foundation

// MARK: - ServingTipsCollectionViewItem

public enum ServingTipsCollectionViewItem: Equatable {
  case imageOption(content: ImageOptionView.Content)
  case titleOption(content: ShortInfoView.Content)
}

// MARK: - ServingTipsCollectionView

//public protocol ServingTipsCollectionViewDelegate: AnyObject {
//  func didSelect(item: ServingTipsCollectionViewItem)
//}

public final class ServingTipsCollectionView: CollectionView, EpoxyableView {

  // MARK: Lifecycle

  public init(style: Style) {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    super.init(layout: layout)
    delaysContentTouches = false
    showsHorizontalScrollIndicator = false
  }

  // MARK: Public

  public struct Style: Hashable {
    public init(id: UUID) {
      self.id = id
    }
    public let id: UUID
  }

  public struct Content: Equatable {
    public let items: [ServingTipsCollectionViewItem]
    public init(items: [ServingTipsCollectionViewItem]) {
      self.items = items
    }
  }

//  public weak var servingTipsCollectionViewDelegate: ServingTipsCollectionViewDelegate?

  public struct Behaviors {
    public let didTap: (ImageOptionView.Content, ImageOptionView) -> Void
    public let willDisplay: (ImageOptionView.Content, ImageOptionView) -> Void
    public init(didTap: @escaping ((ImageOptionView.Content, ImageOptionView) -> Void), willDisplay: @escaping ((ImageOptionView.Content, ImageOptionView) -> Void)) {
      self.didTap = didTap
      self.willDisplay = willDisplay
    }
  }

  public func setBehaviors(_ behaviors: Behaviors?) {
    didTap = behaviors?.didTap
    willDisplay = behaviors?.willDisplay
  }

  public func setContent(_ content: Content, animated: Bool) {
    let sectionModel = SectionModel(dataID: SectionID.servingTipsCollectionViewSection) {
      content.items.enumerated().map { index, content in
        switch content {
        case .imageOption(let content):
          return ImageOptionView.itemModel(
            dataID: String(index) + "ImageOptionView",
            content: content,
            style: .init())
            .flowLayoutItemSize(ImageOptionView.size(for: content))
            .didSelect { [weak self] context in
              self?.didTap?(content, context.view)
            }
            .willDisplay { [weak self] context in
              self?.willDisplay?(content, context.view)
            }

        case .titleOption(let content):
          return ShortInfoView.itemModel(
            dataID: String(index) + "ShortInfoView",
            content: content,
            style: .init())
            .flowLayoutItemSize(ShortInfoView.size(for: content))
        }
      }
    }
    .flowLayoutSectionInset(.init(top: 0, left: 24, bottom: 0, right: 24))

    setSections([sectionModel], animated: true)
  }

  // MARK: Private

  private enum SectionID {
    case servingTipsCollectionViewSection
  }

  private var didTap: ((ImageOptionView.Content, ImageOptionView) -> Void)?
  private var willDisplay: ((ImageOptionView.Content, ImageOptionView) -> Void)?
}
