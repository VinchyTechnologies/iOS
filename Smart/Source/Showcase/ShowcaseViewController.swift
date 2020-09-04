//
//  ShowcaseViewController.swift
//  StartUp
//
//  Created by Aleksei Smirnov on 07.04.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import CommonUI
import VinchyCore
import Display
import StringFormatting

enum ShowcaseMode {
    case normal(wines: [Wine])
    case advancedSearch(params: [(String, String)])
}

final class ShowcaseViewController: UIViewController, UICollectionViewDelegate, Loadable {

    private enum C {
        static let limit: Int = 40
    }

    private(set) var loadingIndicator = ActivityIndicatorView()

    private var categoryItems: [CategoryItem] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    private var filtersHeaderView = ASFiltersHeaderView()

    private lazy var collectionView: UICollectionView = {
        let rowCount = 2
        let inset: CGFloat = 10
        let itemWidth = Int((UIScreen.main.bounds.width - inset * CGFloat(rowCount + 1)) / CGFloat(rowCount))
        let itemHeight = Int(Double(itemWidth)*1.5)

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        layout.minimumLineSpacing = inset
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)

        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        collectionView.register(WineCollectionViewCell.self)
        collectionView.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableView.reuseId)
        collectionView.register(LoadingCollectionFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoadingCollectionFooter.reuseId)

        return collectionView
    }()

    private lazy var dispatchWorkItemHud = DispatchWorkItem { [weak self] in
        guard let self = self else { return }
        self.startLoadingAnimation()
        self.addLoader()
    }

    private var didAddShadow = false
    private var isAnimating = false
    private var currentSection: Int = 0 {
        willSet {
            filtersHeaderView.scrollTo(section: newValue)
        }
    }
    private var currentPage: Int = -1
    private var shouldLoadMore = false

    private let mode: ShowcaseMode

    init(navTitle: String?, mode: ShowcaseMode) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)

        switch mode {
        case .normal(let wines):
            navigationItem.title = navTitle
            let groupedWines = wines.grouped(map: { $0.place?.country ?? "Другие" }) // TODO: - localized
            if groupedWines.count == 1 {
                filtersHeaderView.isHidden = true
                categoryItems = [.init(title: "", wines: wines)]
                return
            }
            categoryItems = groupedWines.map({ (arrayWine) -> CategoryItem in
                // TODO: - localized
                return CategoryItem(title: arrayWine.first?.place?.country ?? "Другие", wines: arrayWine)
            })

        case .advancedSearch(let param):

            navigationItem.title = "Результаты поиска" // TODO: - localized
            if param.first?.0 == "title" && param.count == 1 {
                categoryItems = [.init(title: param.first?.1.quoted ?? "", wines: [])]
            } else {
                categoryItems = [.init(title: "Все", wines: [])] // TODO: - localize
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.dispatchWorkItemHud.perform()
            }
        }
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .mainBackground

        view.addSubview(collectionView)
        filtersHeaderView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        view.addSubview(filtersHeaderView)
    }

    private func fetchCategoryItems() {
        let categoryTitles = categoryItems.compactMap({ $0.title })
        filtersHeaderView.decorate(model: .init(categoryTitles: categoryTitles, filterDelegate: self))
    }

    private func showErrorView(title: String?, description: String?, buttonText: String) {
        let errorView = ErrorView(frame: view.frame)
        errorView.delegate = self
        errorView.configure(title: title, description: description, buttonText: buttonText) // TODO: - localize
        collectionView.backgroundView = errorView
    }

    private func hideErrorView() {
        collectionView.backgroundView = nil
    }

    private func loadMoreWines() {
        guard shouldLoadMore else { return }
        currentPage += 1
        DispatchQueue.global(qos: .userInteractive).async {
            switch self.mode {
            case .normal:
                return

            case .advancedSearch(var params):
                params += [("offset", String(self.currentPage)), ("limit", String(C.limit))]
                Wines.shared.getFilteredWines(params: params) { [weak self] result in
                    guard let self = self else { return }
                    self.dispatchWorkItemHud.cancel()
                    self.stopLoadingAnimation()
                    switch result {
                    case .success(let wines):
                        self.shouldLoadMore = wines.count == C.limit
                        self.categoryItems[0].wines += wines
                        if self.currentPage == 0 && wines.isEmpty {
                            self.showErrorView(title: "Ничего не найдено", description: nil, buttonText: "Назад")
                            return
                        }

                    case .failure(let error):
                        if self.currentPage == 0 {
                            self.hideErrorView()
                            self.showErrorView(title: error.title, description: error.message, buttonText: "Обновить")
                        }
                    }
                }
            }
        }
    }
}

extension ShowcaseViewController: ErrorViewDelegate {

    func didTapErrorButton(_ button: UIButton) {
        loadMoreWines()
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
            cell.decorate(model: .init(imageURL: wine.mainImageUrl ?? "", title: wine.title, subtitle: wine.desc))
            return cell
        }
        return .init()
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderReusableView.reuseId, for: indexPath) as! HeaderReusableView
            let categoryItem = categoryItems[indexPath.section]
            reusableview.decorate(model: .init(title: categoryItem.title))
            return reusableview

        case UICollectionView.elementKindSectionFooter:
            let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoadingCollectionFooter.reuseId, for: indexPath) as! LoadingCollectionFooter
            switch mode {
            case .normal:
                reusableview.loadingIndicator.isAnimating = false
            case .advancedSearch:
                reusableview.loadingIndicator.isAnimating = shouldLoadMore
            }
            return reusableview

        default:
            return .init()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.frame.width, height: filtersHeaderView.isHidden ? 0 : 50)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .init(width: collectionView.bounds.width, height: shouldLoadMore ? 50 : 0)
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

        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let inset = scrollView.contentInset
        let y = offset.y + bounds.size.height - inset.bottom
        let h = scrollView.contentSize.height
        let reload_distance: CGFloat = 100.0
        if y > (h + reload_distance) {
            shouldLoadMore = true
            loadMoreWines()
        }

        if isAnimating { return }

        if let section = collectionView.indexPathsForVisibleSupplementaryElements(ofKind: UICollectionView.elementKindSectionFooter).min()?.section {
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

        if let attributes = collectionView.layoutAttributesForSupplementaryElement(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath) {
            let topOfHeader = CGPoint(x: 0, y: attributes.frame.origin.y - collectionView.contentInset.top)
            collectionView.setContentOffset(topOfHeader, animated: true)
        }
    }
}
