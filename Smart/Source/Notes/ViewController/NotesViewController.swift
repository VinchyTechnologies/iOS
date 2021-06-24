//
//  NotesViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 24.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit
import CommonUI
import Display

// MARK: - NotesViewController

final class NotesViewController: UIViewController, UISearchControllerDelegate, UISearchResultsUpdating {

  // MARK: Internal

  var interactor: NotesInteractorProtocol?

  override func viewDidLoad() {
    super.viewDidLoad()

//    navigationItem.title = localized("notes").firstLetterUppercased()
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    navigationController?.navigationBar.sizeToFit()

    view.addSubview(tableView)
    tableView.fill()


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

// MARK: NotesViewControllerProtocol

extension NotesViewController: NotesViewControllerProtocol {
  func updateUI(viewModel: NotesViewModel) {
    navigationItem.title = viewModel.navigationTitleText
  }
}
