//
//  BottlesCollectionView.swift
//  Smart
//
//  Created by Алексей Смирнов on 13.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Epoxy

// MARK: - BottlesCollectionViewDelegate

protocol BottlesCollectionViewDelegate: AnyObject {
  func didTapShareContextMenu(wineID: Int64, sourceView: UIView)
  func didTapWriteNoteContextMenu(wineID: Int64)
  func didTap(wineID: Int64)
}

// MARK: - BottlesCollectionView

final class BottlesCollectionView: CollectionView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    self.style = style
    super.init(layout: UICollectionViewCompositionalLayout.epoxy)
    delaysContentTouches = false
  }

  // MARK: Internal

  struct Style: Hashable {

    enum Offset {
      case normal, small
    }

    let offset: Offset

    init(offset: Offset = .normal) {
      self.offset = offset
    }
  }

  typealias Content = [WineBottleView.Content]

  weak var bottlesCollectionViewDelegate: BottlesCollectionViewDelegate?

  func setContent(_ content: Content, animated: Bool) {

    let sectionModel = SectionModel(dataID: SectionID.bottlesCollectionViewSectionBottles) {
      content.enumerated().map { index, wineCollectionViewCellViewModel in
        WineBottleView.itemModel(
          dataID: index,
          content: wineCollectionViewCellViewModel,
          style: .init())
          .setBehaviors({ [weak self] context in
            context.view.delegate = self
          })
          .didSelect { [weak self] _ in
            self?.bottlesCollectionViewDelegate?.didTap(wineID: wineCollectionViewCellViewModel.wineID)
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

  private let style: Style

  private var didTap: ((_ wineID: Int64) -> Void)?

  private var layoutSection: NSCollectionLayoutSection? {
    let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(150), heightDimension: .absolute(250)))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(150), heightDimension: .absolute(250)), subitems: [item])
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

// MARK: WineBottleViewDelegate

extension BottlesCollectionView: WineBottleViewDelegate {
  func didTapWriteNoteContextMenu(wineID: Int64) {
    bottlesCollectionViewDelegate?.didTapWriteNoteContextMenu(wineID: wineID)
  }

  func didTapShareContextMenu(wineID: Int64, sourceView: UIView) {
    bottlesCollectionViewDelegate?.didTapShareContextMenu(wineID: wineID, sourceView: sourceView)
  }
}
