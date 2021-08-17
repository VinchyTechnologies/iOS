//
//  FiltersCollectionView.swift
//  Smart
//
//  Created by Алексей Смирнов on 13.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Epoxy

final class FiltersCollectionView: CollectionView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    super.init(layout: UICollectionViewCompositionalLayout.epoxy)
    delaysContentTouches = false
    backgroundColor = .mainBackground

    layer.shadowColor = UIColor.black.withAlphaComponent(0.12).cgColor
    layer.shadowOpacity = 0.0
    layer.shadowOffset = CGSize(width: 0, height: 4)
    clipsToBounds = false
  }

  // MARK: Internal

  struct Style: Hashable {
  }

  typealias Content = [FilterItemView.Content]

  func setContent(_ content: Content, animated: Bool) {

    let sectionModel = SectionModel(dataID: SectionID.filtersCollectionViewSection) {
      content.enumerated().map { index, filterItemViewViewModel in
        FilterItemView.itemModel(
          dataID: index,
          content: filterItemViewViewModel,
          style: .init())
      }
    }
    .compositionalLayoutSection(layoutSection)

    setSections([sectionModel], animated: true)
  }

  // MARK: Private

  private enum SectionID {
    case filtersCollectionViewSection
  }

  private var layoutSection: NSCollectionLayoutSection? {
    let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .estimated(50), heightDimension: .estimated(50)))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .estimated(50), heightDimension: .estimated(50)), subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = 8
    section.orthogonalScrollingBehavior = .continuous
    section.contentInsets = .init(top: 0, leading: 24, bottom: 0, trailing: 24)
    return section
  }
}
