//
//  SearchViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 01.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Core
import Display
import UIKit
import VinchyCore

// MARK: - SearchViewController

final class SearchViewController: UISearchController {

  // MARK: Internal

  //дизайн в loadview, init

  var interactor: SearchInteractorProtocol?

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    interactor?.viewWillAppear()
    collectionView.isHidden = false
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(collectionView)
    collectionView.fill()
    searchBar.delegate = self
  }

  // MARK: Private

  private lazy var layout = UICollectionViewCompositionalLayout { [weak self] sectionNumber, _ -> NSCollectionLayoutSection? in

    guard let self = self else { return nil }

    guard let type = self.viewModel?.sections[sectionNumber] else {
      return nil
    }

    switch type {
    case .title(let model):
      let width = CGFloat(self.collectionView.frame.width - CGFloat(2 * 16))
      let height = CGFloat(TextCollectionCell.height(viewModel: model[sectionNumber], width: width))
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(width), heightDimension: .absolute(height)), subitems: [item])
      group.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 0)
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = .init(top: 15, leading: 8, bottom: 0, trailing: 0)
      return section
    case .recentlySearched:
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(250)))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(150), heightDimension: .absolute(250)), subitems: [item])
      group.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 0)
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = .init(top: 15, leading: 8, bottom: 0, trailing: 0)
      section.orthogonalScrollingBehavior = .continuous
      return section
    }
  }

  private lazy var collectionView: WineDetailCollectionView = {
    let collectionView = WineDetailCollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .mainBackground
    collectionView.dataSource = self
    collectionView.delaysContentTouches = false
    collectionView.register(WineCollectionViewCell.self)
    collectionView.register(TextCollectionCell.self)
    return collectionView
  }()

  private var viewModel: SearchViewModel? {
    didSet {
      collectionView.reloadData()
    }
  }

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
    case .title(let model):
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
    case .title(let model):
      // swiftlint:disable:next force_cast
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCollectionCell.reuseId, for: indexPath) as! TextCollectionCell
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
  func updateUI(didFindWines: [ShortWine]) {
    (searchResultsController as? LegacyResultsTableController)?.set(wines: didFindWines)
  }
}

// MARK: UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
  func searchBar(
    _: UISearchBar,
    textDidChange searchText: String)
  {

    if !searchText.isEmpty {
      collectionView.isHidden = true
    } else {
      collectionView.isHidden = false
    }

    interactor?.didEnterSearchText(searchText)
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    interactor?.didTapSearchButton(searchText: searchBar.text)
  }
}
