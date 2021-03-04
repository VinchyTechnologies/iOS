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

final class CurrencyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  var selectedCurrency: String?
  
  var interactor: CurrencyInteractorProtocol?
  
  private var viewModel = CurrencyViewControllerModel(navigationTitle: "", currencies: []) {
    didSet {
      navigationItem.title = viewModel.navigationTitle
      tableView.reloadData()
    }
  }
  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(CurrencyCell.self, forCellReuseIdentifier: CurrencyCell.reuseId)
    tableView.sectionIndexColor = .dark
    tableView.separatorInset = .zero
    tableView.tableFooterView = UIView()
    
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.largeTitleDisplayMode = .never
    
    view.addSubview(tableView)
    tableView.fill()

    interactor?.viewDidLoad()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.currencies.count
  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath)
    -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyCell.reuseId) as! CurrencyCell // swiftlint:disable:this force_cast
    let model = viewModel.currencies[indexPath.row]
    cell.decorate(model: model)
    return cell
  }
  
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath)
  {
    interactor?.didTapCurrency(symbol:viewModel.currencies[indexPath.row].code ?? "")
  }
  
  func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath)
    -> CGFloat {
    52
  }
  
}
extension CurrencyViewController: CurrencyViewControllerProtocol {
  
  func update(models: CurrencyViewControllerModel) {
    self.viewModel = models
    tableView.reloadData()
  }
}
