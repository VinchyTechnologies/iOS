//
//  StoriesCollectionView.swift
//  Smart
//
//  Created by Алексей Смирнов on 26.10.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import DisplayMini
import EpoxyCollectionView
import EpoxyCore
import Foundation
import VinchyCore

// MARK: - StoriesCollectionViewDelegate

protocol StoriesCollectionViewDelegate: AnyObject {
  func didTapStory(collectionID: Int)
}

// MARK: - StoriesCollectionView

final class StoriesCollectionView: CollectionView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    super.init(layout: UICollectionViewCompositionalLayout.epoxy)
    delaysContentTouches = false
    prefetchDelegate = self
  }

  // MARK: Internal

  struct Style: Hashable {
    let id: String

    init(id: String = UUID().uuidString) {
      self.id = id
    }
  }

  typealias Content = [StoryView.Content]

  weak var storiesCollectionViewDelegate: StoriesCollectionViewDelegate?

  func setContent(_ content: Content, animated: Bool) {

    let sectionModel = SectionModel(dataID: UUID()) {
      content.enumerated().map { index, storyViewViewModel in
        StoryView.itemModel(
          dataID: index,
          content: storyViewViewModel,
          style: .init())
          .didSelect { [weak self] _ in
            self?.storiesCollectionViewDelegate?.didTapStory(collectionID: storyViewViewModel.collectionID)
          }
      }
    }
    .compositionalLayoutSection(layoutSection)

    setSections([sectionModel], animated: true)
  }

  // MARK: Private

  private var layoutSection: NSCollectionLayoutSection? {
    let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(135), heightDimension: .absolute(135)))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(135), heightDimension: .absolute(135)), subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = 8
    section.orthogonalScrollingBehavior = .continuous
    section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
    return section
  }
}

// MARK: CollectionViewPrefetchingDelegate

extension StoriesCollectionView: CollectionViewPrefetchingDelegate {
  func collectionView(_ collectionView: CollectionView, prefetch items: [AnyItemModel]) {
    for item in items {
      if let content = (item.model as? ItemModel<StoryView>)?.erasedContent as? StoryViewViewModel {
        ImageLoader.shared.prefetch(url: content.imageURL)
      }
    }
  }

  func collectionView(_ collectionView: CollectionView, cancelPrefetchingOf items: [AnyItemModel]) {
    for item in items {
      if
        let content = (item.model as? ItemModel<StoryView>)?.erasedContent as? StoryViewViewModel,
        let url = content.imageURL
      {
        ImageLoader.shared.cancelPrefetch([url])
      }
    }
  }
}
