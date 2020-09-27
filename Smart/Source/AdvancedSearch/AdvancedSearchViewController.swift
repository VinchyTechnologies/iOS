//
//  AdvancedSearchViewController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 28.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display
import CommonUI
import Core
import StringFormatting

fileprivate let categoryHeaderID = "categoryHeaderID"
fileprivate let categorySeparatorID = "categorySeparatorID"

final class AdvancedSearchViewController: UIViewController, Alertable {

    private enum C {
        static let maxNumberItems: Int = 9
    }

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    private lazy var searchButton = UIButton(frame: CGRect(x: 20, y: view.bounds.height, width: view.bounds.width - 40, height: 48))

    private var isButtonShown = false

    private(set) var selectedFilters: [(String, String)] = [] {
        didSet {
            if !selectedFilters.isEmpty {
                if !isButtonShown {
                    showButton()
                }
            } else {
                if isButtonShown {
                    hideButton()
                }
            }
        }
    }

    private var selectedIndexPathes: [IndexPath] = []

    private lazy var layout = UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
        switch self.filters[sectionNumber].type {
        case .carusel:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                             heightDimension: .absolute(100)),
                                                           subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: categoryHeaderID, alignment: .topLeading),
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20)), elementKind: categorySeparatorID, alignment: .bottom)]

            if self.filters.count - 1 == sectionNumber {
                section.boundarySupplementaryItems.removeLast()
            }

            return section
        }
    }

    private(set) lazy var filters: [Filter] = loadFilters() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = localized("advanced_search")

        view.addSubview(collectionView)
        collectionView.delaysContentTouches = false
        collectionView.frame = view.frame
        collectionView.backgroundColor = .mainBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AdvancedSearchCaruselCollectionCell.self)
        collectionView.register(AdvancedHeader.self, forSupplementaryViewOfKind: categoryHeaderID, withReuseIdentifier: AdvancedHeader.reuseId)
        collectionView.register(SeparatorFooter.self, forSupplementaryViewOfKind: categorySeparatorID, withReuseIdentifier: SeparatorFooter.reuseId)

        searchButton.setTitle(localized("search").firstLetterUppercased(), for: .normal)
        searchButton.titleLabel?.font = Font.bold(18)
        searchButton.backgroundColor = .accent
        searchButton.layer.cornerRadius = 24
        searchButton.clipsToBounds = true
        searchButton.addTarget(self, action: #selector(didTapSearch(_:)), for: .touchUpInside)

        view.addSubview(searchButton)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 48 + 20, right: 0)
    }

    @objc
    private func didTapSearch(_ button: UIButton) {
        self.navigationController?.pushViewController(Assembly.buildShowcaseModule(navTitle: nil, mode: .advancedSearch(params: selectedFilters)), animated: true)
    }

    private func showButton() {
        isButtonShown = true

        UIView.animate(withDuration: 0.25, animations: {
            let frame = CGRect(x: 20, y: self.view.safeAreaLayoutGuide.layoutFrame.maxY - 58, width: UIScreen.main.bounds.width - 40, height: 48)
            self.searchButton.frame = frame
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    private func hideButton() {
        isButtonShown = false

        UIView.animate(withDuration: 0.25, animations: {
            let frame = CGRect(x: 20, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width - 40, height: 48)
            self.searchButton.frame = frame
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    private func selectFilter(at indexPath: IndexPath) {
        switch filters[indexPath.section].category {
        case .common:
            let secName = filters[indexPath.section].title
            let title = filters[indexPath.section].items[indexPath.row].title

            if secName == "type" {
                selectedFilters.append(("carbon_dioxide", title))
                return
            }

            selectedFilters.append((secName, title))

        case .countries:
            let secName = filters[indexPath.section].title
            let title = filters[indexPath.section].items[indexPath.row].imageName ?? ""
            selectedFilters.append((secName, title))
        }
    }

    private func deselectFilter(at indexPath: IndexPath) {

        switch filters[indexPath.section].category {
        case .common:
            let secName = filters[indexPath.section].title
            let title = filters[indexPath.section].items[indexPath.row].title

            selectedFilters.removeAll { (arg1, arg2) -> Bool in
                var _secName = secName
                if _secName == "type" {
                    _secName = "carbon_dioxide"
                }
                return arg1 == _secName && arg2 == title
            }

        case .countries:
            let secName = filters[indexPath.section].title
            let title = filters[indexPath.section].items[indexPath.row].imageName ?? ""

            selectedFilters.removeAll { (arg1, arg2) -> Bool in
                return arg1 == secName && arg2 == title
            }
        }
    }

    private func showAll(at section: Int) {
        if filters[section].title == "country_code" {
            let preSelectedCountryCodes = selectedFilters.filter({ $0.0 == "country_code" }).map({ $0.1 })
            present(Assembly.buildChooseCountiesModule(preSelectedCountryCodes: preSelectedCountryCodes, delegate: self), animated: true) {
            }
        }
    }
}

extension AdvancedSearchViewController: CountriesViewControllerDelegate {
    func didChoose(countryCodes: [String]) {
        
        let newFilterItems: [FilterItem] = countryCodes.compactMap { (code) -> FilterItem? in
            return FilterItem(title: countryNameFromLocaleCode(countryCode: code) ?? "unknown", imageName: code)
        }

        if let index = filters.firstIndex(where: { $0.title == "country_code" }) {

            selectedFilters.removeAll(where: { $0.0 == "country_code" })
            countryCodes.forEach { (code) in
                selectedFilters.append(("country_code", code))
            }
            selectedIndexPathes.removeAll(where: { $0.section == index })
            newFilterItems.enumerated().forEach { (i, _) in
                selectedIndexPathes.append(IndexPath(row: i, section: index))
            }
            let previousunSelctedItems = loadFilters()[index].items.filter { (filterItem) -> Bool in
                !countryCodes.contains(where: { $0 == filterItem.imageName })
            }
            filters[index].items = (newFilterItems + previousunSelctedItems)
        }
    }
}

extension AdvancedSearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? AdvancedSearchCaruselCollectionCell {
            cell.collectionView.reloadData()
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        filters.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch filters[indexPath.section].category {
        case .common:
            switch filters[indexPath.section].type {
            case .carusel:

                let items = filters[indexPath.section].items.enumerated().map { (index, filterItem) -> ImageOptionCollectionCellViewModel in
                    return .init(imageName: filterItem.imageName,
                                 titleText: localized(filterItem.title).firstLetterUppercased())
                }

                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdvancedSearchCaruselCollectionCell.reuseId, for: indexPath) as! AdvancedSearchCaruselCollectionCell

                let selectedIndexs = selectedIndexPathes
                    .filter({ $0.section == indexPath.section })
                    .compactMap { (indexPath) -> Int? in
                        indexPath.row
                    }

                cell.collectionView.reloadData()
                cell.decorate(model: .init(items: items,
                                           selectedIndexs: selectedIndexs,
                                           section: indexPath.section,
                                           shouldLoadMore: false))
                cell.delegate = self
                return cell
            }

        case .countries:
            switch filters[indexPath.section].type {
            case .carusel:

                let prefix = selectedFilters.filter { $0.0 == "country_code" }.count + C.maxNumberItems

                let items = filters[indexPath.section].items.enumerated().prefix(prefix).map { (index, filterItem) -> ImageOptionCollectionCellViewModel in
                    return .init(imageName: filterItem.imageName,
                                 titleText: countryNameFromLocaleCode(countryCode: filterItem.imageName))
                }

                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdvancedSearchCaruselCollectionCell.reuseId, for: indexPath) as! AdvancedSearchCaruselCollectionCell

                let selectedIndexs = selectedIndexPathes
                    .filter({ $0.section == indexPath.section })
                    .compactMap { (indexPath) -> Int? in
                        indexPath.row
                    }

                cell.decorate(model: .init(items: items,
                                           selectedIndexs: selectedIndexs,
                                           section: indexPath.section,
                                           shouldLoadMore: filters[indexPath.section].items.count >= C.maxNumberItems))
                cell.delegate = self
                return cell
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == categoryHeaderID {
            var title = filters[safe: indexPath.section]?.title ?? ""
            if title == "country_code" {
                title = "country"
            }
            if title == "dish_list" {
                title = "compatibility"
            }
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: AdvancedHeader.reuseId, for: indexPath) as! AdvancedHeader
            header.decorate(model: .init(titleText: localized(title).firstLetterUppercased(), moreText: localized("show_all").firstLetterUppercased(), shouldShowMore: filters[indexPath.section].category == .countries))
            header.section = indexPath.section
            header.delegate = self
            return header
        } else {
            let separator = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SeparatorFooter.reuseId, for: indexPath) as! SeparatorFooter
            return separator
        }
    }
}

extension AdvancedSearchViewController: AdvancedSearchCaruselCollectionCellDelegate {

    func showMore(at section: Int) {
        showAll(at: section)
    }

    func didSelectItem(at indexPath: IndexPath) {
        selectedIndexPathes.append(indexPath)
        selectFilter(at: indexPath)
    }

    func didDeselectItem(at indexPath: IndexPath) {
        selectedIndexPathes.removeAll(where: { $0 == indexPath })
        deselectFilter(at: indexPath)
    }
}

extension AdvancedSearchViewController: AdvancedHeaderDelegate {

    func didTapHeader(at section: Int) {
        showAll(at: section)
    }
}
