//
//  UICollectionViewCompositionalLayout.swift
//  Display
//
//  Created by Алексей Смирнов on 05.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit

extension UICollectionViewCompositionalLayout {
  public static var list: UICollectionViewCompositionalLayout {
    if #available(iOS 14, *) {
      return UICollectionViewCompositionalLayout { _, layoutEnvironment in
        .list(layoutEnvironment: layoutEnvironment)
      }
    }
    return listNoDividers
  }

  public static var listWithHeader: UICollectionViewCompositionalLayout {
    if #available(iOS 14, *) {
      return UICollectionViewCompositionalLayout { _, layoutEnvironment in
        .listWithHeader(layoutEnvironment: layoutEnvironment)
      }
    }
    return listNoDividers
  }

  public static var listNoDividers: UICollectionViewCompositionalLayout {
    UICollectionViewCompositionalLayout { _, _ in
      let item = NSCollectionLayoutItem(
        layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50)))

      let group = NSCollectionLayoutGroup.vertical(
        layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50)),
        subitems: [item])

      return NSCollectionLayoutSection(group: group)
    }
  }
}

// MARK: - NSCollectionLayoutSection

extension NSCollectionLayoutSection {
  public static var carouselWithHeader: NSCollectionLayoutSection {
    let item = NSCollectionLayoutItem(
      layoutSize: .init(widthDimension: .fractionalWidth(0.8), heightDimension: .estimated(50)))

    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: .init(widthDimension: .fractionalWidth(0.8), heightDimension: .estimated(50)),
      subitems: [item])
    group.contentInsets = .zero

    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .groupPaging

    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)),
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top)

    section.boundarySupplementaryItems = [sectionHeader]

    return section
  }

  public static func listWithHeader(
    layoutEnvironment: NSCollectionLayoutEnvironment)
    -> NSCollectionLayoutSection
  {
    let section = list(layoutEnvironment: layoutEnvironment)

    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)),
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top)

    section.boundarySupplementaryItems = [sectionHeader]

    return section
  }

  public static func list(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
    if #available(iOS 14, *) {
      return .list(using: .init(appearance: .plain), layoutEnvironment: layoutEnvironment)
    }

    let item = NSCollectionLayoutItem(
      layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50)))

    let group = NSCollectionLayoutGroup.vertical(
      layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50)),
      subitems: [item])

    return NSCollectionLayoutSection(group: group)
  }
}
