//
//  BottlesCollectionView.swift
//  Smart
//
//  Created by Алексей Смирнов on 13.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Epoxy

final class BottlesCollectionView: CollectionView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    super.init(layout: UICollectionViewCompositionalLayout.epoxy)
    delaysContentTouches = false
  }

  // MARK: Internal

  struct Behaviors {
    var didTap: ((_ wineID: Int64) -> Void)?
  }
  struct Style: Hashable {

  }

  typealias Content = [WineBottleView.Content]

  func setBehaviors(_ behaviors: Behaviors?) {
    didTap = behaviors?.didTap
  }

  func setContent(_ content: Content, animated: Bool) {

    let sectionModel = SectionModel(dataID: SectionID.bottlesCollectionViewSectionBottles) {
      content.enumerated().map { index, wineCollectionViewCellViewModel in
        WineBottleView.itemModel(
          dataID: index,
          content: wineCollectionViewCellViewModel,
          style: .init())
          .didSelect { [weak self] _ in
            self?.didTap?(wineCollectionViewCellViewModel.wineID)
          }
      }
    }
    .compositionalLayoutSection(layoutSection)

    setSections([sectionModel], animated: true)
  }

  // MARK: Private

  private enum SectionID {
    case bottlesCollectionViewSectionBottles
  }

  private var didTap: ((_ wineID: Int64) -> Void)?

  private var layoutSection: NSCollectionLayoutSection? {
    let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(150), heightDimension: .absolute(250)))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(150), heightDimension: .absolute(250)), subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = 8
    section.orthogonalScrollingBehavior = .continuous
    section.contentInsets = .init(top: 0, leading: 24, bottom: 0, trailing: 24)
    return section
  }
}
