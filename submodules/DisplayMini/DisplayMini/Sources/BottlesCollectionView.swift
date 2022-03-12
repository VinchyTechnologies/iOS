//
//  BottlesCollectionView.swift
//  Display
//
//  Created by Алексей Смирнов on 31.10.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import EpoxyCollectionView
import EpoxyCore
import UIKit

// MARK: - BottlesCollectionViewDelegate

public protocol BottlesCollectionViewDelegate: AnyObject {
  func didTapShareContextMenu(wineID: Int64, sourceView: UIView)
  func didTapWriteNoteContextMenu(wineID: Int64)
  func didTap(wineID: Int64)
  func didTapPriceButton(_ button: UIButton, wineID: Int64)
  func bottlesScrollViewDidScroll(_ scrollView: UIScrollView)
}

// MARK: - BottlesCollectionView

public final class BottlesCollectionView: UIView, EpoxyableView {

  // MARK: Lifecycle

  public init(style: Style) {
    self.style = style
    super.init(frame: .zero)
    addSubview(collectionView)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.constrainToSuperview()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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

  public struct Content: Equatable {
    public let wines: [WineBottleView.Content]
    public let contentOffsetX: CGFloat

    public init(wines: [WineBottleView.Content], contentOffsetX: CGFloat = 0) {
      self.wines = wines
      self.contentOffsetX = contentOffsetX
    }
  }


  public weak var bottlesCollectionViewDelegate: BottlesCollectionViewDelegate?

  public lazy var collectionView: CollectionView = {
    $0.delaysContentTouches = false
    $0.prefetchDelegate = self
    $0.alwaysBounceVertical = false
    $0.scrollDelegate = self
    $0.alwaysBounceVertical = false
    $0.alwaysBounceHorizontal = true
    $0.showsVerticalScrollIndicator = false
    $0.showsHorizontalScrollIndicator = false
    return $0
  }(CollectionView(layout: layout))


  public func setContent(_ content: Content, animated: Bool) {
    self.content = content
    let sectionModel = SectionModel(dataID: SectionID.bottlesCollectionViewSectionBottles) {
      content.wines.enumerated().map { index, wineCollectionViewCellViewModel in
        WineBottleView.itemModel(
          dataID: index,
          content: wineCollectionViewCellViewModel,
          style: .init(kind: wineCollectionViewCellViewModel.buttonText?.isNilOrEmpty == false ? .price : .normal))
          .setBehaviors({ [weak self] context in
            context.view.delegate = self
          })
          .didSelect { [weak self] _ in
            self?.bottlesCollectionViewDelegate?.didTap(wineID: wineCollectionViewCellViewModel.wineID)
          }
      }
    }
    .flowLayoutSectionInset(insets)

    collectionView.setSections([sectionModel], animated: false)
    collectionView.layoutIfNeeded() // very important
    collectionView.contentOffset.x = content.contentOffsetX
  }

  // MARK: Private

  private enum SectionID {
    case bottlesCollectionViewSectionBottles
  }


  private var content: Content?

  private let layout: UICollectionViewFlowLayout = {
    $0.minimumInteritemSpacing = 8
    $0.itemSize = .init(width: 150, height: 250)
    $0.scrollDirection = .horizontal
    return $0
  }(UICollectionViewFlowLayout())

  private let style: Style

  private var didTap: ((_ wineID: Int64) -> Void)?


  private var insets: UIEdgeInsets {
    switch style.offset {
    case .normal:
      return .init(top: 0, left: 24, bottom: 0, right: 24)

    case .small:
      return .init(top: 0, left: 16, bottom: 0, right: 16)
    }
  }
}

// MARK: WineBottleViewDelegate

extension BottlesCollectionView: WineBottleViewDelegate {

  public func didTapPriceButton(_ button: UIButton, wineID: Int64) {
    bottlesCollectionViewDelegate?.didTapPriceButton(button, wineID: wineID)
  }

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

// MARK: UIScrollViewDelegate

extension BottlesCollectionView: UIScrollViewDelegate {
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    bottlesCollectionViewDelegate?.bottlesScrollViewDidScroll(scrollView)
  }
}
