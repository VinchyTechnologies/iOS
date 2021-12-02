//
//  ReviewsCollectionView.swift
//  Smart
//
//  Created by Алексей Смирнов on 08.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Epoxy

final class ReviewsCollectionView: CollectionView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    super.init(layout: UICollectionViewCompositionalLayout.epoxy)
    delaysContentTouches = false
  }

  // MARK: Internal

  struct Behaviors {
    var didTap: ((_ reviewID: Int) -> Void)?
  }

  struct Style: Hashable {
  }

  typealias Content = [ReviewView.Content]

  func setBehaviors(_ behaviors: Behaviors?) {
    didTap = behaviors?.didTap
  }

  func setContent(_ content: Content, animated: Bool) {

    let sectionModel = SectionModel(dataID: SectionID.bottlesCollectionViewSectionBottles) {
      content.enumerated().map { index, content in
        ReviewView.itemModel(
          dataID: index,
          content: content,
          style: .init())
          .didSelect { [weak self] _ in
            self?.didTap?(content.id)
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

  private var didTap: ((_ reviewID: Int) -> Void)?

  private var layoutSection: NSCollectionLayoutSection? {
    let width: CGFloat = UIScreen.main.bounds.width > 320 ? 300 : 285
    let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(width), heightDimension: .absolute(200)))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(width), heightDimension: .absolute(200)), subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = 8
    section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
    section.contentInsets = .init(top: 0, leading: 24, bottom: 0, trailing: 24)
    return section
  }
}
