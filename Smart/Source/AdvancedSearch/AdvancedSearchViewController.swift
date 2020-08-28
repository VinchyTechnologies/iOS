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
import VinchyCore

fileprivate let categoryHeaderID = "categoryHeaderID"

final class AdvancedSearchViewController: UIViewController, Alertable {

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    private lazy var searchButton = UIButton(frame: CGRect(x: 20, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width - 40, height: 48))

    private var isButtonShown = false

    private var selectedFilters: [(String, String)] = [] {
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

    private lazy var layout = UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
        switch self.filters[sectionNumber].type {
        case .carusel:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .estimated(180), heightDimension: .fractionalHeight(1)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .estimated(180), heightDimension: .absolute(100)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
            section.interGroupSpacing = 10
            section.boundarySupplementaryItems = [.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: categoryHeaderID, alignment: .topLeading)]
            return section
        }
    }

    private lazy var filters: [Filter] = loadFilters()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = localized("advanced_search")

        view.addSubview(collectionView)
        collectionView.frame = view.frame
        collectionView.backgroundColor = .mainBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageOptionCollectionCell.self)
        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: categoryHeaderID, withReuseIdentifier: HeaderCollectionReusableView.reuseId)

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
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 48 + view.safeAreaInsets.bottom, right: 0)
    }

    @objc
    private func didTapSearch(_ button: UIButton) {
        Wines.shared.getFilteredWines(params: selectedFilters) { [weak self] result in
            switch result {
            case .success(let wines):
                self?.navigationController?.pushViewController(Assembly.buildShowcaseModule(navTitle: nil, wines: wines, fromFilter: true), animated: true)
            case .failure(let error):
                self?.showAlert(message: error.message ?? error.localizedDescription)
            }
        }
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

        let secName = filters[indexPath.section].title
        let title = filters[indexPath.section].items[indexPath.row].title

        if secName == "type" {
            selectedFilters.append(("carbon_dioxide", title))
            return
        }

        selectedFilters.append((secName, title))
    }

    private func deselectFilter(at indexPath: IndexPath) {

        let secName = filters[indexPath.section].title
        let title = filters[indexPath.section].items[indexPath.row].title

        selectedFilters.removeAll { (arg1, arg2) -> Bool in
            var _secName = secName
            if _secName == "type" {
                _secName = "carbon_dioxide"
            }
            return arg1 == _secName && arg2 == title
        }

    }
}

extension AdvancedSearchViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        filters.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filters[section].items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch filters[indexPath.section].type {
        case .carusel:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageOptionCollectionCell.reuseId, for: indexPath) as! ImageOptionCollectionCell
            cell.decorate(model: .init(imageName: filters[indexPath.section].items[indexPath.row].imageName, title: filters[indexPath.section].items[indexPath.row].title.firstLetterUppercased()))
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let title = filters[safe: indexPath.section]?.title ?? ""
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.reuseId, for: indexPath) as! HeaderCollectionReusableView
        header.decorate(model: .init(title: NSAttributedString(string: localized(title).firstLetterUppercased(), font: Font.medium(20), textColor: .blueGray)))
        return header
    }
}

extension AdvancedSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ImageOptionCollectionCell {
            cell.didSelected = !cell.didSelected
            if cell.didSelected {
                selectFilter(at: indexPath)
            } else {
                deselectFilter(at: indexPath)
            }
        }
    }
}
