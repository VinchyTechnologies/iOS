//
//  FakeCollectionView.swift
//  Smart
//
//  Created by Алексей Смирнов on 28.10.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import EpoxyCollectionView
import EpoxyCore

final class FakeCollectionView: CollectionView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    self.style = style
    super.init(layout: UICollectionViewCompositionalLayout.epoxy)
  }

  // MARK: Internal

  struct Style: Hashable {

    enum Kind {
      case big, promo, mini, title
    }

    enum Offset {
      case normal, small
    }

    let offset: Offset
    let kind: Kind

    init(offset: Offset = .small, kind: Kind) {
      self.offset = offset
      self.kind = kind
    }
  }
  typealias Content = [FakeView.Content]

  static func height(for style: Style) -> CGFloat {
    switch style.kind {
    case .big:
      return 250

    case .promo:
      return 120

    case .mini:
      return 135

    case .title:
      return 25
    }
  }

  func setContent(_ content: Content, animated: Bool) {
    let sectionModel = SectionModel(dataID: SectionID.fake) {
      content.enumerated().map { index, content in
        FakeView.itemModel(
          dataID: index,
          content: content,
          style: .init())
      }
    }
    .compositionalLayoutSection(layoutSection)

    setSections([sectionModel], animated: true)
  }

  // MARK: Private

  private enum SectionID {
    case fake
  }

  private let style: Style

  private var didTap: ((_ wineID: Int64) -> Void)?

  private var layoutSection: NSCollectionLayoutSection? {
    let item: NSCollectionLayoutItem
    let group: NSCollectionLayoutGroup

    switch style.kind {
    case .big:
      item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(UIScreen.main.bounds.width - 100), heightDimension: .fractionalHeight(1)))
      group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(UIScreen.main.bounds.width - 100), heightDimension: .fractionalHeight(1)), subitems: [item])

    case .promo:
      item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(UIScreen.main.bounds.width - 60), heightDimension: .fractionalHeight(1)))
      group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(UIScreen.main.bounds.width - 60), heightDimension: .fractionalHeight(1)), subitems: [item])

    case .mini:
      item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(135), heightDimension: .fractionalHeight(1)))
      group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(135), heightDimension: .fractionalHeight(1)), subitems: [item])

    case .title:
      item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(UIScreen.main.bounds.width / 3), heightDimension: .fractionalHeight(1)))
      group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(UIScreen.main.bounds.width / 3), heightDimension: .fractionalHeight(1)), subitems: [item])
    }

    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = 8
    section.orthogonalScrollingBehavior = .continuous

    switch style.offset {
    case .normal:
      section.contentInsets = .init(top: 0, leading: 24, bottom: 0, trailing: 24)

    case .small:
      section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
    }
    return section
  }
}
