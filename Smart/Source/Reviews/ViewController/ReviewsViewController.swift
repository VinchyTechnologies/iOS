//
//  ReviewsViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 20.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import UIKit

// MARK: - ReviewsViewController

final class ReviewsViewController: UIViewController {

  // MARK: Internal

  var interactor: ReviewsInteractorProtocol?

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(collectionView)
    collectionView.fill()
    interactor?.viewDidLoad()
  }

  // MARK: Private

  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.backgroundColor = .mainBackground
    collectionView.delaysContentTouches = false
    collectionView.register(ReviewCell.self, FakeCell.self, LoadingIndicatorCell.self)
    return collectionView
  }()

  private var viewModel: ReviewsViewModel = .init(state: .fake(sections: []), navigationTitle: nil) {
    didSet {
      navigationItem.title = viewModel.navigationTitle
      switch viewModel.state {
      case .fake:
        collectionView.isScrollEnabled = false

      case .normal:
        collectionView.isScrollEnabled = true
      }

      collectionView.reloadData()
    }
  }

  // MARK: - Private Methods

  private func hideErrorView() {
    DispatchQueue.main.async {
      self.collectionView.backgroundView = nil
    }
  }
}

// MARK: UICollectionViewDataSource

extension ReviewsViewController: UICollectionViewDataSource {
  func collectionView(
    _: UICollectionView,
    numberOfItemsInSection section: Int)
    -> Int
  {
    switch viewModel.state {
    case .fake(let sections):
      switch sections[section] {
      case .review(let model):
        return model.count
      }

    case .normal(let sections):
      return sections.count
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell
  {
    switch viewModel.state {
    case .fake(let sections):
      switch sections[indexPath.section] {
      case .review:
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FakeCell.reuseId, for: indexPath)
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        return cell
      }

    case .normal(let sections):
      switch sections[indexPath.row] {
      case .loading:
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingIndicatorCell.reuseId, for: indexPath) as! LoadingIndicatorCell
        return cell

      case .review(let model):
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCell.reuseId, for: indexPath) as! ReviewCell
        cell.decorate(model: model)
        return cell
      }
    }
  }
}

// MARK: UICollectionViewDelegateFlowLayout

extension ReviewsViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _: UICollectionView,
    didSelectItemAt indexPath: IndexPath)
  {
    switch viewModel.state {
    case .fake(let sections):
      switch sections[indexPath.section] {
      case .review:
        return
      }

    case .normal(let sections):
      switch sections[indexPath.row] {
      case .review(let model):
        interactor?.didSelectReview(id: model.id)

      case .loading:
        return
      }
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout _: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath)
    -> CGSize
  {
    switch viewModel.state {
    case .fake(let sections):
      switch sections[indexPath.section] {
      case .review:
        return .init(width: collectionView.frame.width - 32, height: 200)
      }

    case .normal(let sections):
      switch sections[indexPath.row] {
      case .review:
        return .init(width: collectionView.frame.width - 32, height: 200)

      case .loading:
        return .init(width: collectionView.frame.width, height: 48)
      }
    }
  }

  func collectionView(
    _: UICollectionView,
    willDisplay _: UICollectionViewCell,
    forItemAt indexPath: IndexPath)
  {
    switch viewModel.state {
    case .fake:
      break
    case .normal(let sections):
      switch sections[indexPath.row] {
      case .review:
        break

      case .loading:
        interactor?.willDisplayLoadingView()
      }
    }
  }
}

// MARK: ReviewsViewControllerProtocol

extension ReviewsViewController: ReviewsViewControllerProtocol {
  func updateUI(errorViewModel: ErrorViewModel) {
    DispatchQueue.main.async {
      let errorView = ErrorView(frame: self.view.frame)
      errorView.decorate(model: errorViewModel)
      errorView.delegate = self
      self.collectionView.backgroundView = errorView
    }
  }

  func updateUI(viewModel: ReviewsViewModel) {
    hideErrorView()
    self.viewModel = viewModel
  }
}

// MARK: ErrorViewDelegate

extension ReviewsViewController: ErrorViewDelegate {
  func didTapErrorButton(_: UIButton) {
    interactor?.viewDidLoad()
  }
}
