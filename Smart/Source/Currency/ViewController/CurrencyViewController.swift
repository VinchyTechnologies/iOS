//
//  CurrencyViewController.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 2/22/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//
import UIKit
import Display
import StringFormatting
import Core

final class CurrencyViewController: UITableViewController {
  
  var selectedCurrency: String?
  
  var interactor: CurrencyInteractorProtocol?
  
  var currencies = [CurrencyCellViewModel]()
  
   override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.largeTitleDisplayMode = .never
    navigationItem.title = localized("currency").firstLetterUppercased()
    tableView.tableFooterView = UIView()
    tableView.separatorInset = .zero
    tableView.register(CurrencyCell.self, forCellReuseIdentifier: CurrencyCell.reuseId)
    interactor?.viewDidLoad()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return currencies.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyCell.reuseId) as? CurrencyCell {
      let model = currencies[indexPath.row]
      cell.decorate(text: model.title, isSelectes: model.isSelected)
      return cell
    }
    return .init()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    interactor?.didTapCurrency(symbol: currencies[indexPath.row].title)
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    52
  }
 
}
extension CurrencyViewController: CurrencyViewControllerProtocol {
  
  func update(models: [CurrencyCellViewModel]) {
    currencies = models
    tableView.reloadData()
  }
}
