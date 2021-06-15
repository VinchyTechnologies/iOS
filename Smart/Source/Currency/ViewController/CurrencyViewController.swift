//
//  CurrencyViewController.swift
//  Smart
//
//  Created by Tatiana Ampilogova on 2/22/21.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//
import Core
import Display
import StringFormatting
import UIKit

// MARK: - CurrencyViewController

final class CurrencyViewController: UIViewController {

  // MARK: Internal

  var interactor: CurrencyInteractorProtocol?

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.largeTitleDisplayMode = .never

    view.addSubview(tableView)
    tableView.fill()

    interactor?.viewDidLoad()
  }

  // MARK: Private

  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(CurrencyCell.self, forCellReuseIdentifier: CurrencyCell.reuseId)
    tableView.separatorInset = .zero
    tableView.tableFooterView = UIView()

    return tableView
  }()

  private var viewModel = CurrencyViewControllerModel(navigationTitle: "", currencies: []) {
    didSet {
      navigationItem.title = viewModel.navigationTitle
      tableView.reloadData()
    }
  }
}

// MARK: UITableViewDataSource

extension CurrencyViewController: UITableViewDataSource {
  func tableView(
    _: UITableView,
    numberOfRowsInSection _: Int)
    -> Int
  {
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
}

// MARK: UITableViewDelegate

extension CurrencyViewController: UITableViewDelegate {
  func tableView(
    _: UITableView,
    didSelectRowAt indexPath: IndexPath)
  {
    interactor?.didTapCurrency(symbol: viewModel.currencies[indexPath.row].code)
  }

  func tableView(
    _: UITableView,
    heightForRowAt _: IndexPath)
    -> CGFloat
  {
    52
  }
}

// MARK: CurrencyViewControllerProtocol

extension CurrencyViewController: CurrencyViewControllerProtocol {
  func update(viewModel: CurrencyViewControllerModel) {
    self.viewModel = viewModel
  }
}
