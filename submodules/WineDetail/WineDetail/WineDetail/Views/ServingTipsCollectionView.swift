//
//  ServingTipsCollectionView.swift
//  Smart
//
//  Created by Алексей Смирнов on 10.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import EpoxyCollectionView
import EpoxyCore

// MARK: - ServingTipsCollectionViewItem

enum ServingTipsCollectionViewItem: Equatable {
  case imageOption(content: ImageOptionView.Content)
  case titleOption(content: ShortInfoView.Content)
}

// MARK: - ServingTipsCollectionView

final class ServingTipsCollectionView: CollectionView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    super.init(layout: layout)
    delaysContentTouches = false
    showsHorizontalScrollIndicator = false
  }

  // MARK: Internal

  struct Style: Hashable {
  }

  struct Content: Equatable {
    let items: [ServingTipsCollectionViewItem]
  }

  func setContent(_ content: Content, animated: Bool) {
    let sectionModel = SectionModel(dataID: SectionID.servingTipsCollectionViewSection) {
      content.items.enumerated().map { index, content in
        switch content {
        case .imageOption(let content):
          return ImageOptionView.itemModel(
            dataID: String(index) + "ImageOptionView",
            content: content,
            style: .init())
            .flowLayoutItemSize(ImageOptionView.size(for: content))

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
}
