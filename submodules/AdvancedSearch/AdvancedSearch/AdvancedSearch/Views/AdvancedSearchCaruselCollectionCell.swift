//
//  AdvancedSearchCaruselCollectionCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 13.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import DisplayMini
import UIKit

// MARK: - AdvancedSearchCaruselCollectionCellDelegate

public protocol AdvancedSearchCaruselCollectionCellDelegate: AnyObject {
  func didSelectItem(at indexPath: IndexPath)
  //  func setContentOffset(_ offset: CGPoint, at section: Int)
  //  func showMore(at section: Int)
}

// MARK: - AdvancedSearchCaruselCollectionCellViewModel

public struct AdvancedSearchCaruselCollectionCellViewModel: ViewModelProtocol {
  fileprivate let items: [ImageOptionCollectionCellViewModel]
  fileprivate let shouldLoadMore: Bool

  public init(items: [ImageOptionCollectionCellViewModel], shouldLoadMore: Bool) {
    self.items = items
    self.shouldLoadMore = shouldLoadMore
  }
}

// MARK: - AdvancedSearchCaruselCollectionCell

final class AdvancedSearchCaruselCollectionCell: UICollectionViewCell, Reusable {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)

    collectionView.dataSource = self
    collectionView.delegate = self

    addSubview(collectionView)
    collectionView.fill()
//    bounceDecorator.configureBounceDecorator(onView: self)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Internal

  weak var delegate: AdvancedSearchCaruselCollectionCellDelegate?
  var section: Int = 0

  var decorationBounceViewInsets: UIEdgeInsets = .init(top: 0, left: 24, bottom: 0, right: 24)

  let collectionView: UICollectionView = {
    let layout = DecoratorFlowLayout()
    layout.scrollDirection = .horizontal
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .clear
    collectionView.register(ImageOptionCollectionCell.self)
    collectionView.delaysContentTouches = false
    collectionView.contentInset = .init(top: 0, left: 15, bottom: 0, right: 15)
    collectionView.showsHorizontalScrollIndicator = false
    return collectionView
  }()

  // MARK: Private

//  private lazy var bounceDecorationView: MoreBounceDecoratorView = {
//    let view = MoreBounceDecoratorView()
//    view.decorate(model: .init(titleText: "More"))
//    return view
//  }()
//
//  private lazy var bounceDecorator: ScrollViewBounceDecorator = {
//    let left = decorationBounceViewInsets.left - collectionView.contentInset.left
//    let right = decorationBounceViewInsets.right
//    let direction: ScrollViewBounceDecorator.ScrollDirection =
//      .horizontal(.right(.init(top: 0, left: left, bottom: 0, right: left))) // TODO: - fix Arabic
//
//    return ScrollViewBounceDecorator(
//      decorationView: bounceDecorationView,
//      direction: direction,
//      isFadingEnabled: false,
//      delegate: self)
//  }()

  private var items: [ImageOptionCollectionCellViewModel] = [] {
    didSet {
      collectionView.reloadData()
    }
  }
}

// MARK: Decoratable

extension AdvancedSearchCaruselCollectionCell: Decoratable {
  typealias ViewModel = AdvancedSearchCaruselCollectionCellViewModel

  func decorate(model: AdvancedSearchCaruselCollectionCellViewModel) {
    items = model.items
//    bounceDecorator.isEnabled = false
  }
}

// MARK: UICollectionViewDataSource

extension AdvancedSearchCaruselCollectionCell: UICollectionViewDataSource {
  func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
    items.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell
  {
    // swiftlint:disable:next force_cast
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageOptionCollectionCell.reuseId, for: indexPath) as! ImageOptionCollectionCell
    cell.decorate(model: items[indexPath.row])
    return cell
  }
}

// MARK: DecoratorFlowLayoutDelegate

extension AdvancedSearchCaruselCollectionCell: DecoratorFlowLayoutDelegate {

  // MARK: Public

  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
//    delegate?.setContentOffset(scrollView.contentOffset, at: section)
//    bounceDecorator.handleScrollViewDidScroll(scrollView)
  }

  public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate _: Bool) {
//    bounceDecorator.handleScrollViewDidEndDragging(scrollView)
  }

  // MARK: Internal

  func collectionView(
    _: UICollectionView,
    didSelectItemAt indexPath: IndexPath)
  {
    delegate?.didSelectItem(at: IndexPath(row: indexPath.row, section: section))
  }

  func collectionView(
    _: UICollectionView,
    layout _: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath)
    -> CGSize
  {
    ImageOptionCollectionCell.size(for: items[indexPath.row])
  }
}

// MARK: ScrollViewBounceDecoratorDelegate

//extension AdvancedSearchCaruselCollectionCell: ScrollViewBounceDecoratorDelegate {
//  func scrollViewBounceDecoratorTriggered() {
////    delegate?.showMore(at: section)
//  }
//}
