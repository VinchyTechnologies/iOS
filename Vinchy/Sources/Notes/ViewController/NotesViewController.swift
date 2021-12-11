//
//  NotesViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 24.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Combine
import Display
import DisplayMini
import StringFormatting
import UIKit

// MARK: - NotesViewController

final class NotesViewController: UIViewController {

  // MARK: Internal

  var interactor: NotesInteractorProtocol?

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.backgroundColor = .mainBackground

    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    navigationController?.navigationBar.sizeToFit()

    view.addSubview(tableView)
    tableView.fill()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    interactor?.viewWillAppear()
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

  private var viewModel: NotesViewModel? {
    didSet {
      navigationItem.title = viewModel?.navigationTitleText
      tableView.reloadData()
    }
  }
}

// MARK: UITableViewDelegate

extension NotesViewController: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath)
  {
    tableView.deselectRow(at: indexPath, animated: true)
    guard let type = viewModel?.sections[safe: indexPath.section] else {
      return
    }
    switch type {
    case .simpleNote(let model):
      interactor?.didTapNoteCell(wineID: model[indexPath.row].wineID)
    }
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
      // swiftlint:disable:next force_cast
      let cell = tableView.dequeueReusableCell(withIdentifier: WineTableCell.reuseId, for: indexPath) as! WineTableCell
      cell.decorate(model: model[indexPath.row])
      return cell
    }
  }

  func tableView(
    _: UITableView,
    commit editingStyle: UITableViewCell.EditingStyle,
    forRowAt indexPath: IndexPath)
  {
    if editingStyle == .delete {

      guard let type = viewModel?.sections[indexPath.section] else {
        return
      }

      switch type {
      case .simpleNote(let model):
        interactor?.didTapDeleteCell(wineID: model[indexPath.row].wineID)
      }
    }
  }

  func tableView(
    _: UITableView,
    titleForDeleteConfirmationButtonForRowAt _: IndexPath)
    -> String?
  {
    viewModel?.titleForDeleteConfirmationButton
  }
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

  func hideEmptyView() {
    tableView.backgroundView = nil
  }

  func showEmptyView(title: String, subtitle: String) {
    let errorView = ErrorView(frame: view.frame)
    errorView.decorate(model: .init(
      titleText: title.firstLetterUppercased(),
      subtitleText: subtitle.firstLetterUppercased(),
      buttonText: nil))
    tableView.backgroundView = errorView
  }
}

// MARK: Alertable

extension NotesViewController: Alertable {

  @discardableResult
  func showAlert(wineID: Int64, title: String, firstActionTitle: String, secondActionTitle: String, message: String?) -> AnyPublisher<Void, Never> {
    Future { _ in
      let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: firstActionTitle, style: .destructive, handler: { [weak self] _ in
        guard let self = self else { return }
        self.interactor?.didTapConfirmDeleteCell(wineID: wineID)
      }))
      alertController.addAction(UIAlertAction(title: secondActionTitle, style: .cancel, handler: nil))
      self.present(alertController, animated: true, completion: nil)
    }
    .handleEvents(receiveCancel: {
      self.dismiss(animated: true)
    })
    .eraseToAnyPublisher()
  }
}

// MARK: ScrollableToTop

extension NotesViewController: ScrollableToTop {
  var scrollableToTopScrollView: UIScrollView {
    tableView
  }
}
