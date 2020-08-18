//
//  ShowcaseViewController.swift
//  StartUp
//
//  Created by Aleksei Smirnov on 07.04.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import RealmSwift
import CommonUI
import VinchyCore

final class ShowcaseViewController: UIViewController, UICollectionViewDelegate {

    private enum Constants {
        static let filtersHeaderViewHeight: CGFloat = 50
        static let bottomCartHeight: CGFloat = 40
        static let inset: CGFloat = 10
        static let rowCount = 2
    }

    private var categoryItems: [CategoryItem] = []
    private var filtersHeaderView = ASFiltersHeaderView()
    private var collectionView: UICollectionView?
    private var didAddShadow = false
    private var isAnimating = false
    private var currentSection: Int = 0 {
        willSet {
            filtersHeaderView.scrollTo(section: newValue)
        }
    }

    init(navTitle: String?, wines: [Wine], fromFilter: Bool) {
        super.init(nibName: nil, bundle: nil)

        if fromFilter {
            navigationItem.title = "Результаты поиска" // TODO: - localized

            if wines.isEmpty {
                categoryItems = [.init(title: "Ничего не найдено", wines: [])]
                return
            }

            categoryItems = [.init(title: "Все", wines: wines)] // TODO: - add quotes

            return
        }
        navigationItem.title = navTitle

        let groupedWines = wines.grouped(map: { $0.place.country ?? "" })

        if groupedWines.isEmpty {
            categoryItems = [.init(title: "Ничего не найдено", wines: [])]
            return
        }

        if groupedWines.count == 1 {
            categoryItems = [.init(title: "Все", wines: wines)] // TODO: - localize
            return
        }

    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .mainBackground

        let rowCount = Constants.rowCount
        let itemWidth = Int((UIScreen.main.bounds.width - Constants.inset * CGFloat(rowCount + 1)) / CGFloat(rowCount))
        let itemHeight = Int(Double(itemWidth)*1.5)

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: Constants.inset, bottom: 0, right: Constants.inset)
        layout.minimumLineSpacing = Constants.inset
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)

        if let collectionView = collectionView {
            view.addSubview(collectionView)

            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.backgroundColor = .clear
            collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            collectionView.register(WineCollectionViewCell.self,
                                    forCellWithReuseIdentifier: WineCollectionViewCell.reuseId)
            collectionView.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableView.description())
            collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: UICollectionReusableView.description())

            filtersHeaderView.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: Constants.filtersHeaderViewHeight)
            view.addSubview(filtersHeaderView.view)

        }

        fetchCategoryItems()

    }

    private func fetchCategoryItems() {
        let categoryTitles = categoryItems.compactMap({ $0.title })
        filtersHeaderView.decorate(model: .init(categoryTitles: categoryTitles, filterDelegate: self))
    }

    private func showErrorView() {
        let errorView = ErrorView(frame: view.frame)
        errorView.delegate = self
        errorView.configure(title: "Что-то пошло не так :(", description: "Нет сети", buttonText: "Обновить") // TODO: - localize
        collectionView?.backgroundView = errorView
    }

    private func hideErrorView() {
        collectionView?.backgroundView = nil
    }
}

// MARK: - ErrorViewDelegate

extension ShowcaseViewController: ErrorViewDelegate {

    func didTapErrorButton(_ button: UIButton) {
        print("refresh")
    }

}

extension ShowcaseViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        categoryItems.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categoryItems[section].wines.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WineCollectionViewCell.reuseId, for: indexPath) as? WineCollectionViewCell,
            let wine = categoryItems[safe: indexPath.section]?.wines[safe: indexPath.row] {
            cell.decorate(model: .init(imageURL: wine.mainImageUrl, title: wine.title, subtitle: wine.desc))
            return cell
        }
        return .init()
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if
            kind == UICollectionView.elementKindSectionHeader,

            let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderReusableView.description(), for: indexPath) as? HeaderReusableView,

            let categoryItem = categoryItems[safe: indexPath.section] {

            reusableview.decorate(model: .init(title: categoryItem.title))

            return reusableview
        }

        let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UICollectionReusableView.description(), for: indexPath)
        return reusableview
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.frame.width, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {

        if section == categoryItems.count - 1 {
            return .init(width: collectionView.frame.width, height: 10)
        }

        return .init(width: 1, height: 0.1)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView.contentOffset.y > 0 {
            if !didAddShadow {
                UIView.animate(withDuration: 0.5) {
                    self.filtersHeaderView.addSoftUIEffectForView()
                    self.didAddShadow = true
                }
            }
        } else {
            if didAddShadow {
                UIView.animate(withDuration: 0.5) {
                    self.filtersHeaderView.removeSoftUIEffectForView()
                    self.didAddShadow = false
                }
            }
        }

        if isAnimating { return }

        if let section = collectionView?.indexPathsForVisibleSupplementaryElements(ofKind: UICollectionView.elementKindSectionFooter).min()?.section {
            isAnimating = false
            if section != currentSection {
                currentSection = section
            }
        }
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isAnimating = false
        filtersHeaderView.isUserIntaractionEnabled(true)
    }

}

extension ShowcaseViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let wine = categoryItems[safe: indexPath.section]?.wines[safe: indexPath.row] else { return }
        navigationController?.pushViewController(Assembly.buildDetailModule(wineID: wine.id), animated: true)
    }

}

extension ShowcaseViewController: FiltersHeaderViewDelegate {
    func didTapFilter(index: Int) {
        isAnimating = true
        filtersHeaderView.isUserIntaractionEnabled(currentSection != index)

        let indexPath = IndexPath(item: 0, section: index)

        if let collectionView = collectionView,
            let attributes = collectionView.layoutAttributesForSupplementaryElement(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath) {
            let topOfHeader = CGPoint(x: 0, y: attributes.frame.origin.y - collectionView.contentInset.top)
            collectionView.setContentOffset(topOfHeader, animated: true)
        }
    }
}
