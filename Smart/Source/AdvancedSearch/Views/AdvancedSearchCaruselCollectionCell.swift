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
    func didDeselectItem(at indexPath: IndexPath)
    func showMore(at section: Int)
}

public struct AdvancedSearchCaruselCollectionCellViewModel: ViewModelProtocol {

    fileprivate let items: [ImageOptionCollectionCellViewModel]
    fileprivate let selectedIndexs: [Int]
    fileprivate let section: Int
    fileprivate let shouldLoadMore: Bool

    public init(items: [ImageOptionCollectionCellViewModel], selectedIndexs: [Int], section: Int, shouldLoadMore: Bool) {
        self.items = items
        self.selectedIndexs = selectedIndexs
        self.section = section
        self.shouldLoadMore = shouldLoadMore
    }
}

final class AdvancedSearchCaruselCollectionCell: UICollectionViewCell, Reusable {

    weak var delegate: AdvancedSearchCaruselCollectionCellDelegate?

    private var items: [ImageOptionCollectionCellViewModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.bounceDecorator.changeZoom(withPercent: 0)
            }
        }
    }

    private var selectedIndexs: [Int] = []

    private var section: Int = 0

    private lazy var bounceDecorationView: MoreBounceDecoratorView = {
        let view = MoreBounceDecoratorView()
        view.decorate(model: .init(titleText: "More"))
        return view
    }()

    var decorationBounceViewInsets: UIEdgeInsets = .init(top: 0, left: 24, bottom: 0, right: 24)

    private lazy var bounceDecorator: ScrollViewBounceDecorator = {
        let left = decorationBounceViewInsets.left - collectionView.contentInset.left
        let right = decorationBounceViewInsets.right
        let direction: ScrollViewBounceDecorator.ScrollDirection = .horizontal(.right(.init(top: 0, left: left, bottom: 0, right: left))) // TODO: - Arabic

        return ScrollViewBounceDecorator(
            decorationView: bounceDecorationView,
            direction: direction,
            isFadingEnabled: false,
            delegate: self)
    }()

    private let collectionView: UICollectionView = {
        let layout = DecoratorFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
}

extension AdvancedSearchCaruselCollectionCell: Decoratable {

    typealias ViewModel = AdvancedSearchCaruselCollectionCellViewModel

    func decorate(model: AdvancedSearchCaruselCollectionCellViewModel) {
        self.selectedIndexs = model.selectedIndexs
        self.items = model.items
        self.section = model.section
        bounceDecorator.isEnabled = false//model.shouldLoadMore
    }
}

extension AdvancedSearchCaruselCollectionCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageOptionCollectionCell.reuseId, for: indexPath) as! ImageOptionCollectionCell
        cell.decorate(model: items[indexPath.row])
        cell.setSelected(flag: selectedIndexs.contains(indexPath.row), animated: false)
        return cell
    }

}

extension AdvancedSearchCaruselCollectionCell: DecoratorFlowLayoutDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ImageOptionCollectionCell {
            let flag = !selectedIndexs.contains(indexPath.row)
            cell.setSelected(flag: flag, animated: true)
            if !selectedIndexs.contains(indexPath.row) {
                selectedIndexs.append(indexPath.row)
                delegate?.didSelectItem(at: IndexPath(row: indexPath.row, section: section))
            } else {
                selectedIndexs.removeAll(where: { $0 == indexPath.row })
                delegate?.didDeselectItem(at: IndexPath(row: indexPath.row, section: section))
            }
        }
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        bounceDecorator.handleScrollViewDidScroll(scrollView)
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        bounceDecorator.handleScrollViewDidEndDragging(scrollView)
    }
}

extension AdvancedSearchCaruselCollectionCell: ScrollViewBounceDecoratorDelegate {
    func scrollViewBounceDecoratorTriggered() {
        delegate?.showMore(at: section)
    }
}

