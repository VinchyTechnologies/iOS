//
//  FiltersViewController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 21.06.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import AsyncDisplayKit
import StringFormatting
import Core
import CommonUI
import Display
import VinchyCore

final class FiltersViewController: ASDKViewController<FiltersNode>, Alertable {

    private var selectedFilters: [(String, String)] = [] {
        didSet {
            if !selectedFilters.isEmpty {
                if !node.isButtonShown {
                    node.showButton()
                }
            } else {
                if node.isButtonShown {
                    node.hideButton()
                }
            }
        }
    }

    private lazy var filters: [Filter] = loadFilters()

    override init() {
        let node = FiltersNode()
        super.init(node: node)
        navigationItem.title = localized("advanced_search")
        node.tableNode.delegate = self
        node.tableNode.dataSource = self
        node.searchButton.addTarget(self, action: #selector(didTapSearch(_:)), for: .touchUpInside)
    }

    required init?(coder: NSCoder) { fatalError() }

    @objc private func didTapSearch(_ button: UIButton) {
        Wines.shared.getFilteredWines(params: selectedFilters) { [weak self] result in
            switch result {
            case .success(let wines):
                self?.navigationController?.pushViewController(Assembly.buildShowcaseModule(navTitle: nil, wines: wines, fromFilter: true), animated: true)
            case .failure(let error):
                self?.showAlert(message: error.message ?? error.localizedDescription)
            }
        }
    }
}

extension FiltersViewController: ASTableDataSource {

    func numberOfSections(in tableNode: ASTableNode) -> Int {
        filters.count
    }

    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        switch filters[safe: indexPath.section]?.type {
        case .carusel:
            let cell = CaruselFilterNode()
            let items = filters[safe: indexPath.section]?.items.map { (filterItem) -> CaruselFilterNodeViewModel.CaruselFilterItem in
                return CaruselFilterNodeViewModel.CaruselFilterItem(title: filterItem.title, imageName: filterItem.imageName)
                } ?? []
            cell.decorate(model: .init(items: items))
            cell.section = indexPath.section
            cell.delegate = self
            return cell
        case .none:
            return .init()
        }
    }
}

extension FiltersViewController: ASTableDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = TableViewHeader()
        header.decorate(model: .init(title: localized(filters[section].title).firstLetterUppercased()))
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        filters[section].title.isEmpty ? 0 : 44
    }
}

extension FiltersViewController: CaruselFilterNodeDelegate {

    func didSelectFilter(cell: CaruselFilterNode, title: String) {
        if let sec = cell.section, let filter = filters[safe: sec] {

            if filter.title == "type" {
                selectedFilters.append(("carbon_dioxide", title))
                return
            }
            selectedFilters.append((filter.title, title))
        }
    }

    func didDeSelectFilter(cell: CaruselFilterNode, title: String) {
        if let sec = cell.section, let filter = filters[safe: sec] {
            selectedFilters.removeAll { (arg1, arg2) -> Bool in
                arg1 == filter.title && arg2 == title
            }
        }
    }
}

