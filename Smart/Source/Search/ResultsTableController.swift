//
//  ResultsTableController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.06.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import CommonUI
import VinchyCore

final class ResultsTableController: UIViewController {

    // MARK: - Public Properties

    var didFoundProducts: [Wine] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    let tableView = UITableView()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        extendedLayoutIncludesOpaqueBars = true

        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.dataSource = self

        tableView.register(WineTableCell.self, forCellReuseIdentifier: WineTableCell.reuseId)
        tableView.tableFooterView = UIView()

    }
}

extension ResultsTableController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        didFoundProducts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: WineTableCell.reuseId) as? WineTableCell,
            let wine = didFoundProducts[safe: indexPath.row] {
            cell.decorate(model: .init(imageURL: wine.mainImageUrl, title: wine.title, subtitle: wine.desc))
            return cell
        }
        return .init()
    }
}
