//
//  StoriesCollectionView.swift
//  Smart
//
//  Created by Алексей Смирнов on 26.10.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Epoxy

// MARK: - StoriesCollectionViewDelegate

protocol StoriesCollectionViewDelegate: AnyObject {
  func didTapStory(id: Int)
}

// MARK: - StoriesCollectionView

final class StoriesCollectionView: CollectionView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    super.init(layout: UICollectionViewCompositionalLayout.epoxy)
    delaysContentTouches = false
  }

  // MARK: Internal

  struct Style: Hashable {
  }

  typealias Content = [StoryView.Content]

  weak var bottlesCollectionViewDelegate: StoriesCollectionViewDelegate?

  func setContent(_ content: Content, animated: Bool) {

    let sectionModel = SectionModel(dataID: SectionID.storiesCollectionViewSection) {
      content.enumerated().map { index, storyViewViewModel in
        StoryView.itemModel(
          dataID: index,
          content: storyViewViewModel,
          style: .init())
          .didSelect { [weak self] _ in
//            self?.storiesCollectionViewDelegate?.didTap(wineID: storyViewViewModel.id)
          }
      }
    }
    .compositionalLayoutSection(layoutSection)

    setSections([sectionModel], animated: true)
  }

  // MARK: Private

  private enum SectionID {
    case storiesCollectionViewSection
  }

  private var didTap: ((_ wineID: Int64) -> Void)?

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
