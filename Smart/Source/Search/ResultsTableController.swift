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
  
  private var didFoundProducts: [Wine] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  
  private let tableView = UITableView()

  private lazy var bottomConstraint = NSLayoutConstraint(
    item: tableView,
    attribute: .bottom,
    relatedBy: .equal,
    toItem: view,
    attribute: .bottom,
    multiplier: 1,
    constant: 0)

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(tableView)
    tableView.frame = view.frame
    tableView.keyboardDismissMode = .onDrag

    tableView.dataSource = self
    tableView.estimatedRowHeight = 65

    tableView.register(WineTableCell.self, forCellReuseIdentifier: WineTableCell.reuseId)
    tableView.register(DidnotFindTheWineTableCell.self,
                       forCellReuseIdentifier: DidnotFindTheWineTableCell.reuseId)
    tableView.tableFooterView = UIView()
  }

  func set(wines: [Wine]) {
    didFoundProducts = wines
  }

  func getWines() -> [Wine] {
    didFoundProducts
  }

  func set(constant: CGFloat) {
    bottomConstraint.constant = constant
  }

  func set(delegate: UITableViewDelegate) {
    tableView.delegate = delegate
  }
}

extension ResultsTableController: UITableViewDataSource {
  
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int)
  -> Int
  {
    didFoundProducts.count == 0 ? 1 : didFoundProducts.count
  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath)
  -> UITableViewCell
  {
    
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
