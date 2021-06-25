//
//  NotesViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 24.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Display
import UIKit

// MARK: - NotesViewController

final class NotesViewController: UIViewController {

  // MARK: Internal

  var interactor: NotesInteractorProtocol?

  var viewModel: NotesViewModel? {
    didSet {
      navigationItem.title = viewModel?.navigationTitleText
      tableView.reloadData()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    navigationController?.navigationBar.sizeToFit()

    view.addSubview(tableView)
    tableView.fill()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    interactor?.viewDidLoad()
  }

  // MARK: Private

  private lazy var searchController: UISearchController = {
    let searchController = UISearchController(searchResultsController: nil)
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.autocapitalizationType = .none
    searchController.searchBar.searchTextField.font = Font.medium(20)
    searchController.searchBar.searchTextField.layer.cornerRadius = 20
    searchController.searchBar.searchTextField.layer.masksToBounds = true
    searchController.searchBar.searchTextField.layer.cornerCurve = .continuous
    searchController.delegate = self
    searchController.searchResultsUpdater = self
    searchController.hidesNavigationBarDuringPresentation = true
    return searchController
  }()

  private lazy var tableView: UITableView = {
    $0.dataSource = self
    $0.delegate = self
    $0.tableFooterView = UIView()
    $0.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    $0.register(WineTableCell.self, forCellReuseIdentifier: WineTableCell.reuseId)
    return $0
  }(UITableView())

}

// MARK: UITableViewDelegate

extension NotesViewController: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath)
  {
    tableView.deselectRow(at: indexPath, animated: true)
    interactor?.didTapNoteCell(at: indexPath)
  }

  func scrollViewWillBeginDragging(_: UIScrollView) {
    if !navigationItem.hidesSearchBarWhenScrolling {
      navigationItem.hidesSearchBarWhenScrolling = true
    }
  }
}

// MARK: UITableViewDataSource

extension NotesViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let type = viewModel?.sections[safe: section] else {
      return 0
    }
    switch type {
    case .simpleNote(let model):
      return model.count
    }
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    viewModel?.sections.count ?? 0
  }

  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath)
    -> UITableViewCell
  {
    guard let type = viewModel?.sections[indexPath.section] else {
      return .init()
    }

    switch type {
    case .simpleNote(let model):
      if let cell = tableView.dequeueReusableCell(withIdentifier: WineTableCell.reuseId) as? WineTableCell {
        cell.decorate(model: model[indexPath.row])
        return cell
      }
      return .init()
    }
  }

  func tableView(
    _: UITableView,
    commit editingStyle: UITableViewCell.EditingStyle,
    forRowAt indexPath: IndexPath)
  {

  }

//  func tableView(
//    _: UITableView,
//    titleForDeleteConfirmationButtonForRowAt _: IndexPath)
//    -> String?
//  {
//    //localized("delete")
//  }
}

// MARK: UISearchControllerDelegate

extension NotesViewController: UISearchControllerDelegate {

}

// MARK: UISearchResultsUpdating

extension NotesViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    interactor?.didEnterSearchText(searchController.searchBar.text)
  }
}

// MARK: NotesViewControllerProtocol

extension NotesViewController: NotesViewControllerProtocol {
  func updateUI(viewModel: NotesViewModel) {
    self.viewModel = viewModel
  }
}
