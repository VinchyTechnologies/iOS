//
//  BottlesCollectionView.swift
//  Display
//
//  Created by Алексей Смирнов on 31.10.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

@_exported import EpoxyCollectionView
@_exported import EpoxyCore
import UIKit

// MARK: - BottlesCollectionViewDelegate

public protocol BottlesCollectionViewDelegate: AnyObject {
  func didTapShareContextMenu(wineID: Int64, sourceView: UIView)
  func didTapWriteNoteContextMenu(wineID: Int64)
  func didTap(wineID: Int64)
}

// MARK: - BottlesCollectionView

public final class BottlesCollectionView: CollectionView, EpoxyableView {

  // MARK: Lifecycle

  public init(style: Style) {
    self.style = style
    super.init(layout: UICollectionViewCompositionalLayout.epoxy)
    delaysContentTouches = false
    prefetchDelegate = self
  }

  // MARK: Public

  public struct Style: Hashable {

    public enum Offset {
      case normal, small
    }

    public let id: String
    public let offset: Offset

    public init(id: String = UUID().uuidString, offset: Offset = .normal) {
      self.id = id
      self.offset = offset
    }
  }

  public typealias Content = [WineBottleView.Content]

  public weak var bottlesCollectionViewDelegate: BottlesCollectionViewDelegate?

  public func setContent(_ content: Content, animated: Bool) {

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
  public func didTapWriteNoteContextMenu(wineID: Int64) {
    bottlesCollectionViewDelegate?.didTapWriteNoteContextMenu(wineID: wineID)
  }

  public func didTapShareContextMenu(wineID: Int64, sourceView: UIView) {
    bottlesCollectionViewDelegate?.didTapShareContextMenu(wineID: wineID, sourceView: sourceView)
  }
}

// MARK: CollectionViewPrefetchingDelegate

extension BottlesCollectionView: CollectionViewPrefetchingDelegate {
  public func collectionView(_ collectionView: CollectionView, prefetch items: [AnyItemModel]) {
    for item in items {
      if let content = (item.model as? ItemModel<WineBottleView>)?.erasedContent as? WineBottleView.Content {
        ImageLoader.shared.prefetch(url: content.imageURL)
      }
    }
  }

  public func collectionView(_ collectionView: CollectionView, cancelPrefetchingOf items: [AnyItemModel]) {
    for item in items {
      if
        let content = (item.model as? ItemModel<WineBottleView>)?.erasedContent as? WineBottleView.Content,
        let url = content.imageURL
      {
        ImageLoader.shared.cancelPrefetch([url])
      }
    }
  }
}
