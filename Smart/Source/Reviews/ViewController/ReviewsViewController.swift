//
//  ReviewsViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 20.02.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import UIKit
import CommonUI

final class ReviewsViewController: UIViewController {
  
  var interactor: ReviewsInteractorProtocol?
  
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(collectionView)
    collectionView.fill()
    interactor?.viewDidLoad()
  }
  
  // MARK: - Private Methods
  
  private func hideErrorView() {
    DispatchQueue.main.async {
      self.collectionView.backgroundView = nil
    }
  }
}

extension ReviewsViewController: UICollectionViewDataSource {
  
  func collectionView(
    _ collectionView: UICollectionView,
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

extension ReviewsViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
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
    _ collectionView: UICollectionView,
    willDisplay cell: UICollectionViewCell,
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

// MARK: - ReviewsViewControllerProtocol

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

extension ReviewsViewController: ErrorViewDelegate {
  func didTapErrorButton(_ button: UIButton) {
    interactor?.viewDidLoad()
  }
}
