//
//  AdvancedSearchCaruselCollectionCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 13.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display
import CommonUI

public protocol AdvancedSearchCaruselCollectionCellDelegate: AnyObject {
  func didSelectItem(at indexPath: IndexPath)
  func setContentOffset(_ offset: CGPoint, at section: Int)
//  func showMore(at section: Int)
}

public struct AdvancedSearchCaruselCollectionCellViewModel: ViewModelProtocol {

  fileprivate let items: [ImageOptionCollectionCellViewModel]
  fileprivate let shouldLoadMore: Bool

  public init(items: [ImageOptionCollectionCellViewModel], shouldLoadMore: Bool) {
    self.items = items
    self.shouldLoadMore = shouldLoadMore
  }
}

final class AdvancedSearchCaruselCollectionCell: UICollectionViewCell, Reusable {

  weak var delegate: AdvancedSearchCaruselCollectionCellDelegate?
  var section: Int = 0

  private var items: [ImageOptionCollectionCellViewModel] = [] {
    didSet {
      collectionView.reloadData()
    }
  }

  private lazy var bounceDecorationView: MoreBounceDecoratorView = {
    let view = MoreBounceDecoratorView()
    view.decorate(model: .init(titleText: "More"))
    return view
  }()

  var decorationBounceViewInsets: UIEdgeInsets = .init(top: 0, left: 24, bottom: 0, right: 24)

  private lazy var bounceDecorator: ScrollViewBounceDecorator = {
    let left = decorationBounceViewInsets.left - collectionView.contentInset.left
    let right = decorationBounceViewInsets.right
    let direction: ScrollViewBounceDecorator.ScrollDirection = .horizontal(.right(.init(top: 0, left: left, bottom: 0, right: left))) // TODO: - fix Arabic

    return ScrollViewBounceDecorator(
      decorationView: bounceDecorationView,
      direction: direction,
      isFadingEnabled: false,
      delegate: self)
  }()

  let collectionView: MyCollectionView = {
    let layout = DecoratorFlowLayout()
    layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    layout.scrollDirection = .horizontal
    let collectionView = MyCollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .clear
    collectionView.register(ImageOptionCollectionCell.self)
    collectionView.delaysContentTouches = false
    collectionView.contentInset = .init(top: 0, left: 15, bottom: 0, right: 15)
    collectionView.showsHorizontalScrollIndicator = false

    return collectionView
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    collectionView.dataSource = self
    collectionView.delegate = self

    addSubview(collectionView)
    collectionView.fill()
    bounceDecorator.configureBounceDecorator(onView: self)
  }

  required init?(coder: NSCoder) { fatalError() }

  public func setContentOffset(_ contentOffset: CGPoint) {
    collectionView.setContentOffset(contentOffset, animated: false)
  }
}

extension AdvancedSearchCaruselCollectionCell: Decoratable {

  typealias ViewModel = AdvancedSearchCaruselCollectionCellViewModel

  func decorate(model: AdvancedSearchCaruselCollectionCellViewModel) {
    items = model.items
    bounceDecorator.isEnabled = false
  }
}

extension AdvancedSearchCaruselCollectionCell: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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

extension AdvancedSearchCaruselCollectionCell: DecoratorFlowLayoutDelegate {

  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath)
  {
    delegate?.didSelectItem(at: IndexPath(row: indexPath.row, section: section))
  }

  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    delegate?.setContentOffset(scrollView.contentOffset, at: section)
    bounceDecorator.handleScrollViewDidScroll(scrollView)
  }

  public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    bounceDecorator.handleScrollViewDidEndDragging(scrollView)
  }
}

extension AdvancedSearchCaruselCollectionCell: ScrollViewBounceDecoratorDelegate {
  func scrollViewBounceDecoratorTriggered() {
//    delegate?.showMore(at: section)
  }
}

class MyCollectionView: UICollectionView {

  private var temporaryOffsetOverride: CGPoint?

  override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  deinit {
    removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset))
  }

  private func setup() {
    self.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset), options: [.old, .new], context: nil)
  }

  override func reloadData() {
    if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout, flowLayout.estimatedItemSize == UICollectionViewFlowLayout.automaticSize {
      temporaryOffsetOverride = contentOffset
    }
    super.reloadData()
  }

  override func observeValue(
    forKeyPath keyPath: String?,
    of object: Any?,
    change: [NSKeyValueChangeKey: Any]?,
    context: UnsafeMutableRawPointer?) {
    if keyPath == #keyPath(UIScrollView.contentOffset) {
      if let offset = temporaryOffsetOverride {
        temporaryOffsetOverride = nil
        self.setContentOffset(offset, animated: false)
      }
    }
  }
}
