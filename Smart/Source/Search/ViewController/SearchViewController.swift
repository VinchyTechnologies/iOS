//
//  SearchViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 01.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Display
import UIKit

// MARK: - SearchViewController

final class SearchViewController: UIViewController {

  // MARK: Internal

  var interactor: SearchInteractorProtocol?

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(collectionView)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.fill()

    interactor?.viewDidLoad()
  }

  // MARK: Private

  private var viewModel: SearchViewModel? {
    didSet {
      collectionView.reloadData()
    }
  }

  private lazy var layout = UICollectionViewCompositionalLayout { [weak self] sectionNumber, _ -> NSCollectionLayoutSection? in

    guard let self = self else { return nil }

    guard let type = self.viewModel?.sections[sectionNumber] else {
      return nil
    }

    switch type {
    case .recentlySearched:
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(80), heightDimension: .absolute(250)))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(250)), subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = .init(top: 15, leading: 0, bottom: 0, trailing: 0)
      section.orthogonalScrollingBehavior = .continuous
      return section
    }
  }

  private lazy var collectionView: WineDetailCollectionView = {
    let collectionView = WineDetailCollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .mainBackground
    collectionView.dataSource = self
//    collectionView.delegate = self
    collectionView.delaysContentTouches = false
    collectionView.register(WineCollectionViewCell.self)
    return collectionView
  }()
}

// MARK: UICollectionViewDataSource

extension SearchViewController: UICollectionViewDataSource {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    viewModel?.sections.count ?? 0
  }

  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int)
    -> Int
  {
    switch viewModel?.sections[safe: section] {
    case .recentlySearched(let model):
      return model.count

    case .none:
      return 0
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell
  {

    switch viewModel?.sections[safe: indexPath.section] {
    case .recentlySearched(let model):
      // swiftlint:disable:next force_cast
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WineCollectionViewCell.reuseId, for: indexPath) as! WineCollectionViewCell
      cell.decorate(model: model[indexPath.row])
      return cell

    case .none:
      return .init()
    }
  }
}

// MARK: SearchViewControllerProtocol

extension SearchViewController: SearchViewControllerProtocol {
  func updateUI(viewModel: SearchViewModel) {
    self.viewModel = viewModel
  }
}
