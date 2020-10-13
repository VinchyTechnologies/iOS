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
import EmailService
import StringFormatting

final class ResultsTableController: UIViewController {

    weak var didnotFindTheWineTableCellDelegate: DidnotFindTheWineTableCellProtocol?

    var didFoundProducts: [Wine] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        extendedLayoutIncludesOpaqueBars = true

        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.dataSource = self
        tableView.estimatedRowHeight = 65

        tableView.register(WineTableCell.self, forCellReuseIdentifier: WineTableCell.reuseId)
        tableView.register(DidnotFindTheWineTableCell.self,
                           forCellReuseIdentifier: DidnotFindTheWineTableCell.reuseId)
        tableView.tableFooterView = UIView()
    }
}

extension ResultsTableController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        didFoundProducts.count == 0 ? 1 : didFoundProducts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard !didFoundProducts.isEmpty else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: DidnotFindTheWineTableCell.reuseId) as? DidnotFindTheWineTableCell {
                cell.delegate = didnotFindTheWineTableCellDelegate
                return cell
            }
            return .init()
        }

        if let cell = tableView.dequeueReusableCell(withIdentifier: WineTableCell.reuseId) as? WineTableCell,
            let wine = didFoundProducts[safe: indexPath.row] {
            cell.decorate(model: .init(imageURL: wine.mainImageUrl?.toURL, titleText: wine.title, subtitleText: countryNameFromLocaleCode(countryCode: wine.winery?.countryCode)))
            return cell
        }
        return .init()
    }
}
