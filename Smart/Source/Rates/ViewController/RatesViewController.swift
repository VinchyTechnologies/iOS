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
    interactor?.viewDidLoad()
  }

  // MARK: Private

  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = .mainBackground
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
        cell.delegate = self
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
        interactor?.didSelectReview(wineID: model.wineID)

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

  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
  {
    nil
  }

  @available(iOS 11.0, *)
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
  {
    switch viewModel.state {
    case .normal(let sections):
      switch sections[indexPath.row] {
      case .review(let model):
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .default)

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, _ in
          self?.interactor?.didSwipeToDelete(reviewID: model.reviewID)
        }
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash", withConfiguration: imageConfig)

        let editAction = UIContextualAction(style: .destructive, title: "Edit") { [weak self] _, _, _ in
          self?.interactor?.didSwipeToEdit(reviewID: model.reviewID)
        }
        editAction.image = UIImage(systemName: "pencil", withConfiguration: imageConfig)
        editAction.backgroundColor = .systemOrange

        let shareAction = UIContextualAction(style: .destructive, title: "Share") { [weak self] _, _, _ in
          guard let sourceView = tableView.cellForRow(at: indexPath) else { return }
          self?.interactor?.didSwipeToShare(reviewID: model.reviewID, sourceView: sourceView)
        }
        shareAction.image = UIImage(systemName: "square.and.arrow.up", withConfiguration: imageConfig)
        shareAction.backgroundColor = .systemBlue

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction, shareAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration

      case .loading:
        return nil
      }
    }
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

// MARK: WineRateTableCellDelegate

extension RatesViewController: WineRateTableCellDelegate {
  func didTapMore(reviewID: Int) {
    interactor?.didTapMore(reviewID: reviewID)
  }
}
