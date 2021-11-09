//
//  RatesViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 06.11.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Core
import UIKit

// MARK: - RatesViewController

final class RatesViewController: UIViewController {

  // MARK: Internal

  var interactor: RatesInteractorProtocol?

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(tableView)
    tableView.fill()

    handleSwipeToDelete()
    updateUI(viewModel: .init(state: .normal(items: [.review(WineRateView.Content.init(bottleURL: nil, titleText: "Brut ChampagnBrut ChampagnBrut ChampagnBrut ChampagnBrut Champagn", reviewText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur", readMoreText: "Read more", wineryText: "Dom Perignon Dom Perignon Dom Perignon Dom Perignon Dom Perignon", starValue: 4.5))]), navigationTitle: "alalal"))
    //    interactor?.viewDidLoad()
  }

  // MARK: Private

  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = .mainBackground
    tableView.delaysContentTouches = false
    tableView.register(LoadingIndicatorTableCell.self, forCellReuseIdentifier: LoadingIndicatorTableCell.reuseId)
    tableView.register(WineRateTableCell.self, forCellReuseIdentifier: WineRateTableCell.reuseId)
    return tableView
  }()

  private var viewModel: RatesViewModel = .init(state: .normal(items: []), navigationTitle: nil) {
    didSet {
      navigationItem.title = viewModel.navigationTitle
      switch viewModel.state {
      case .normal:
        tableView.isScrollEnabled = true
      }

      tableView.reloadData()
    }
  }

  private func handleSwipeToDelete() {
    guard let pageController = parent as? PageViewController else {
      return
    }

    pageController.scrollView.canCancelContentTouches = false
    tableView.gestureRecognizers?.forEach { recognizer in
      let name = String(describing: type(of: recognizer))
      guard name == encodeText("`VJTxjqfBdujpoQboHftuvsfSfdphoj{fs", -1) else {
        return
      }
      pageController.scrollView.panGestureRecognizer.require(toFail: recognizer)
    }
  }

  private func hideErrorView() {
    DispatchQueue.main.async {
      self.tableView.backgroundView = nil
    }
  }
}

// MARK: UITableViewDataSource

extension RatesViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch viewModel.state {
    case .normal(let sections):
      return sections.count
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch viewModel.state {
    case .normal(let sections):
      switch sections[indexPath.row] {
      case .loading:
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: LoadingIndicatorTableCell.reuseId, for: indexPath) as! LoadingIndicatorTableCell
        return cell

      case .review(let model):
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: WineRateTableCell.reuseId, for: indexPath) as! WineRateTableCell
        cell.decorate(model: model)
        return cell
      }
    }
  }
}

// MARK: UITableViewDelegate

extension RatesViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    switch viewModel.state {
    case .normal(let sections):
      switch sections[indexPath.row] {
      case .review(let model):
        return
//        interactor?.didSelectReview(id: model.id)

      case .loading:
        return
      }
    }
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch viewModel.state {
    case .normal(let sections):
      switch sections[indexPath.row] {
      case .review(let content):
        return WineRateTableCell.height(for: content, width: tableView.frame.width)

      case .loading:
        return 48
      }
    }
  }

  func tableView(
    _ tableView: UITableView,
    willDisplay cell: UITableViewCell,
    forRowAt indexPath: IndexPath)
  {
    switch viewModel.state {
    case .normal(let sections):
      switch sections[indexPath.row] {
      case .review:
        break

      case .loading:
        interactor?.willDisplayLoadingView()
      }
    }
  }

  func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
    UIContextMenuConfiguration(
      identifier: nil,
      previewProvider: nil,
      actionProvider: {
        suggestedActions in
        let inspectAction =
          UIAction(
            title: NSLocalizedString("InspectTitle", comment: ""),
            image: UIImage(systemName: "arrow.up.square")) { action in
          }
        let duplicateAction =
          UIAction(
            title: NSLocalizedString("DuplicateTitle", comment: ""),
            image: UIImage(systemName: "plus.square.on.square")) { action in
          }
        let deleteAction =
          UIAction(
            title: "Delete",
            image: UIImage(systemName: "trash"),
            attributes: .destructive) { action in
          }
        return UIMenu(title: "", children: [inspectAction, duplicateAction, deleteAction])
      })
  }

  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
  {
    nil
  }

  @available(iOS 11.0, *)
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
  {
    let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, handler in
      //YOUR_CODE_HERE
    }
    deleteAction.backgroundColor = .red
    let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
    configuration.performsFirstActionWithFullSwipe = false
    return configuration
  }
}

// MARK: RatesViewControllerProtocol

extension RatesViewController: RatesViewControllerProtocol {
  func updateUI(errorViewModel: ErrorViewModel) {
    DispatchQueue.main.async {
      let errorView = ErrorView(frame: self.view.frame)
      errorView.decorate(model: errorViewModel)
      errorView.delegate = self
      self.tableView.backgroundView = errorView
    }
  }

  func updateUI(viewModel: RatesViewModel) {
    hideErrorView()
    self.viewModel = viewModel
  }
}

// MARK: ErrorViewDelegate

extension RatesViewController: ErrorViewDelegate {
  func didTapErrorButton(_: UIButton) {
    interactor?.viewDidLoad()
  }
}

// MARK: UIGestureRecognizerDelegate

//extension RatesViewController: UIGestureRecognizerDelegate {
//  func gestureRecognizer(
//    _ gestureRecognizer: UIGestureRecognizer,
//    shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer)
//    -> Bool
//  {
//    true
//  }
//}
