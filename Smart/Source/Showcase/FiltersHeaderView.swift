//
//  FiltersHeaderView.swift
//  ASUI
//
//  Created by Aleksei Smirnov on 28.04.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display
import CommonUI

public protocol FiltersHeaderViewDelegate: AnyObject {
    func didTapFilter(index: Int)
}

struct ASFiltersHeaderViewModel: ViewModelProtocol {
    let categoryTitles: [String]
    let filterDelegate: FiltersHeaderViewDelegate?
}

final class ASFiltersHeaderView: UIView {

    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

    private var categoryTitles: [String] = [] {
        didSet {
            DispatchQueue.main.async {

                CATransaction.begin()
                CATransaction.setCompletionBlock({
                    self.hilightFirst()
                })
                self.collectionView.reloadData()
                CATransaction.commit()
            }
        }
    }

    private weak var filterDelegate: FiltersHeaderViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        collectionView.register(TextCollectionCell.self)
        collectionView.frame = frame
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .mainBackground
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func hilightFirst() {
        if let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? TextCollectionCell {
            cell.decorate(model: .init(title: NSAttributedString(string: cell.getCurrentText() ?? "", attributes: ASTextNodeAttributes.common(size: 16, textColor: .accent))))
        }
    }

    public func isUserIntaractionEnabled(_ flag: Bool) {
        isUserInteractionEnabled = flag
    }

    public func scrollTo(section: Int) {
        collectionView.scrollToItem(at: IndexPath(item: section, section: 0), at: .centeredHorizontally, animated: true)
        collectionView.visibleCells.forEach { (cell) in
            if let cell = cell as? TextCollectionCell {
                if cell == self.collectionView.cellForItem(at: IndexPath(item: section, section: 0)) {
                    cell.decorate(model: .init(title: NSAttributedString(string: cell.getCurrentText() ?? "", attributes: ASTextNodeAttributes.common(size: 16, textColor: .dark))))
                } else {
                    cell.decorate(model: .init(title: NSAttributedString(string: cell.getCurrentText() ?? "", attributes: ASTextNodeAttributes.common(size: 16, textColor: .blueGray))))
                }
            }
        }
    }

    func addSoftUIEffectForView(themeColor: UIColor = UIColor(red: 241/255, green: 243/255, blue: 246/255, alpha: 1.0)) {
        clipsToBounds = false
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowColor = UIColor(red: 223/255, green: 228/255, blue: 238/255, alpha: 1.0).cgColor

        let shadowLayer = CAShapeLayer()
        shadowLayer.frame = bounds
        shadowLayer.backgroundColor = themeColor.cgColor
        shadowLayer.shadowColor = UIColor.white.cgColor
        shadowLayer.shadowOffset = CGSize(width: -2.0, height: -2.0)
        shadowLayer.shadowOpacity = 1
        shadowLayer.shadowRadius = 2
        self.layer.insertSublayer(shadowLayer, at: 0)
    }

    func removeSoftUIEffectForView() {
        self.clipsToBounds = true
    }
}

extension ASFiltersHeaderView: Decoratable {

    typealias ViewModel = ASFiltersHeaderViewModel

    func decorate(model: ViewModel) {
        self.categoryTitles = model.categoryTitles
        self.filterDelegate = model.filterDelegate
    }
}

extension ASFiltersHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categoryTitles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCollectionCell.reuseId, for: indexPath) as! TextCollectionCell
        cell.decorate(model: .init(title: NSAttributedString(string: categoryTitles[safe: indexPath.row] ?? "",
                                                             attributes: ASTextNodeAttributes.common(size: 16, textColor: .secondaryLabel))))
        return cell
    }
}

extension ASFiltersHeaderView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

        collectionView.visibleCells.forEach { (cell) in
            if let cell = cell as? TextCollectionCell {
                if cell == collectionView.cellForItem(at: indexPath) {
                    cell.decorate(model: .init(title: NSAttributedString(string: cell.getCurrentText() ?? "", attributes: ASTextNodeAttributes.common(size: 16, textColor: .accent))))
                } else {
                    cell.decorate(model: .init(title: NSAttributedString(string: cell.getCurrentText() ?? "",
                                                                         attributes: ASTextNodeAttributes.common(size: 16, textColor: .blueGray))))
                }
            }
        }

        filterDelegate?.didTapFilter(index: indexPath.row)
    }
}
