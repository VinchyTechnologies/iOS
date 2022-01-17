//
//  RatesViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 06.11.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core
import Database
import DisplayMini
import StringFormatting
import ThirdParty
import UIKit
import VinchyUI

// MARK: - RatesViewController

final class RatesViewController: UIViewController {

  // MARK: Public

  public lazy var pullToRefreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(
      self,
      action: #selector(didTriggerPullToRefreshControl),
      for: .valueChanged)
    return refreshControl
  }()

  // MARK: Internal

  private(set) var loadingIndicator = ActivityIndicatorView()

  var interactor: RatesInteractorProtocol?

  private(set) lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = .mainBackground
    tableView.register(LoadingIndicatorTableCell.self, forCellReuseIdentifier: LoadingIndicatorTableCell.reuseId)
    tableView.register(WineRateTableCell.self, forCellReuseIdentifier: WineRateTableCell.reuseId)
    tableView.refreshControl = pullToRefreshControl
    tableView.tableFooterView = UIView()
    return tableView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(tableView)
    tableView.fill()

    handleSwipeToDelete()
    interactor?.viewDidLoad()
  }

  // MARK: Private

  private var viewModel: RatesViewModel = .init(state: .normal(items: []), navigationTitle: nil) {
    didSet {
      navigationItem.title = viewModel.navigationTitle
      switch viewModel.state {
      case .normal:
        hideErrorView()
        tableView.isScrollEnabled = true

      case .noLogin(let model), .error(let model), .noContent(let model):
        updateUI(errorViewModel: model)
        tableView.isScrollEnabled = false
      }

      tableView.reloadData()
    }
  }

  @objc
  private func didTriggerPullToRefreshControl() {
    interactor?.didPullToRefresh()
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

    case .noLogin, .error, .noContent:
      return 0
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

    case .noLogin, .error, .noContent:
      return UITableViewCell()
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

    case .error, .noLogin, .noContent:
      return
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

    case .noLogin, .error, .noContent:
      return 0
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

    case .error, .noLogin, .noContent:
      return
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

        let deleteAction = UIContextualAction(style: .destructive, title: localized("delete").firstLetterUppercased()) { [weak self] _, _, complete in
          self?.interactor?.didSwipeToDelete(reviewID: model.reviewID)
          complete(true)
        }
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash", withConfiguration: imageConfig)

        let editAction = UIContextualAction(style: .destructive, title: localized("edit").firstLetterUppercased()) { [weak self] _, _, complete in
          self?.interactor?.didSwipeToEdit(reviewID: model.reviewID)
          complete(true)
        }
        editAction.image = UIImage(systemName: "pencil", withConfiguration: imageConfig)
        editAction.backgroundColor = .systemOrange

        let shareAction = UIContextualAction(style: .destructive, title: localized("share").firstLetterUppercased()) { [weak self] _, _, complete in
          guard let sourceView = tableView.cellForRow(at: indexPath) else { return }
          self?.interactor?.didSwipeToShare(reviewID: model.reviewID, sourceView: sourceView)
          complete(true)
        }
        shareAction.image = UIImage(systemName: "square.and.arrow.up", withConfiguration: imageConfig)
        shareAction.backgroundColor = .systemBlue

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction, shareAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration

      case .loading:
        return nil
      }

    case .noLogin, .error, .noContent:
      return nil
    }
  }
}

// MARK: RatesViewControllerProtocol

extension RatesViewController: RatesViewControllerProtocol {

  func stopPullRefreshing() {
    pullToRefreshControl.endRefreshing()
  }

  func updateUI(errorViewModel: ErrorViewModel) {
    DispatchQueue.main.async {
      let errorView = ErrorView(frame: self.view.frame)
      errorView.decorate(model: errorViewModel)
      errorView.delegate = self
      self.tableView.backgroundView = errorView
    }
  }

  func updateUI(viewModel: RatesViewModel) {
    self.viewModel = viewModel
    stopPullRefreshing()
  }
}

// MARK: ErrorViewDelegate

extension RatesViewController: ErrorViewDelegate {
  func didTapErrorButton(_: UIButton) {
    switch viewModel.state {
    case .normal, .noContent:
      return // impossible case

    case .noLogin:
      interactor?.didTapLoginButton()

    case .error:
      interactor?.viewDidLoad()
    }
  }
}

// MARK: WineRateTableCellDelegate

extension RatesViewController: WineRateTableCellDelegate {
  func didTapMore(reviewID: Int) {
    interactor?.didTapMore(reviewID: reviewID)
  }
}

// MARK: AuthorizationOutputDelegate

extension RatesViewController: AuthorizationOutputDelegate {
  func didSuccessfullyRegister(output: AuthorizationOutputModel?) {
  }

  func didSuccessfullyLogin(output: AuthorizationOutputModel?) {
  }
}
