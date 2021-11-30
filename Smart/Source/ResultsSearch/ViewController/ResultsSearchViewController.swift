//
//  ResultsSearchViewController.swift
//  Smart
//
//  Created by Михаил Исаченко on 23.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Display
import Epoxy
import StringFormatting
import UIKit
import VinchyCore

// MARK: - ResultsSearchDelegate

protocol ResultsSearchDelegate: AnyObject {
  func didTapBottleCell(wineID: Int64)
  func didTapSearchButton(searchText: String?)
}

// MARK: - ResultsSearchViewController

final class ResultsSearchViewController: UIViewController {

  // MARK: Lifecycle

  init(input: ResultsSearchInput) {
    self.input = input
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  var interactor: ResultsSearchInteractorProtocol?

  weak var didnotFindTheWineCollectionCellDelegate: DidnotFindTheWineCollectionCellProtocol?
  weak var resultsSearchDelegate: ResultsSearchDelegate?

  override func viewDidLoad() {
    super.viewDidLoad()
    edgesForExtendedLayout = [] // this fixes offset on iPad

    switch input.mode {
    case .normal:
      view.addSubview(collectionView)
      collectionView.fill()
      collectionView.backgroundColor = .mainBackground

    case .storeDetail:
      collectionView.backgroundColor = .clear
      view.backgroundColor = .clear
      view.addSubview(blurEffectView)
      blurEffectView.translatesAutoresizingMaskIntoConstraints = false
      blurEffectView.constrainToSuperview()

      topBarInstaller.install()
      if let container = topBarInstaller.container {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
          collectionView.topAnchor.constraint(equalTo: container.bottomAnchor),
          collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
          collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
      }
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    interactor?.viewWillAppear()
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    let blurEffect = UIBlurEffect(style: traitCollection.userInterfaceStyle == .dark ? .dark : .light)
    blurEffectView.effect = blurEffect
  }

  // MARK: Private

  private lazy var blurEffectView = UIVisualEffectView()

  private lazy var topBarInstaller = TopBarInstaller(
    viewController: self,
    bars: bars)

  private let input: ResultsSearchInput

  // swiftformat:disable:next redundantType
  private lazy var layout: UICollectionViewCompositionalLayout = UICollectionViewCompositionalLayout { [weak self] sectionNumber, _ -> NSCollectionLayoutSection? in

    guard let self = self else { return nil }

    switch self.viewModel?.state {
    case .history(let sections):
      switch sections[sectionNumber] {
      case .recentlySearched:
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(250)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(150), heightDimension: .absolute(250)), subitems: [item])
        group.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 15, leading: 11, bottom: 0, trailing: 11)
        section.orthogonalScrollingBehavior = .continuous
        return section

      case .titleRecentlySearched(let model):
        let width = CGFloat(self.collectionView.frame.width - CGFloat(2 * 16))
        let height = CGFloat(TextCollectionCell.height(viewModel: model[sectionNumber], width: width))
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(width), heightDimension: .absolute(height)), subitems: [item])
        group.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 15, leading: 8, bottom: 0, trailing: 0)
        return section
      }

    case .results(let sections):
      switch sections[sectionNumber] {
      case .didNotFindTheWine:
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(65)), subitems: [item])
        group.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        return section

      case .searchResults:
        let width = CGFloat(self.collectionView.frame.width - CGFloat(2 * 16))
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(width), heightDimension: .absolute(130)), subitems: [item])
        group.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 0)
        return section
      }

    case .none:
      return nil
    }
  }

  private lazy var collectionView: UICollectionView = {
    let collectionView = WineDetailCollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.delaysContentTouches = false
    collectionView.keyboardDismissMode = .onDrag

    collectionView.register(
      WineCollectionCell.self,
      DidnotFindTheWineCollectionCell.self,
      WineCollectionViewCell.self,
      TextCollectionCell.self)

    return collectionView
  }()

  @BarModelBuilder
  private var bars: [BarModeling] {
    [
      SearchBar.barModel(
        dataID: nil,
        content: .init(),
        behaviors: .init(didTapCancel: { [weak self] in
          self?.dismiss(animated: true)
        }, didEnterSearchText: { [weak self] searchText in
          self?.interactor?.didEnterSearchText(searchText)
        }),
        style: .init())
        .willDisplay { context in
          context.view.searchBar.becomeFirstResponder()
        },
    ]
  }

  private var viewModel: ResultsSearchViewModel? {
    didSet {
      collectionView.reloadData()
    }
  }
}

// MARK: ResultsSearchViewControllerProtocol

extension ResultsSearchViewController: ResultsSearchViewControllerProtocol {
  func updateUI(viewModel: ResultsSearchViewModel) {
    self.viewModel = viewModel
  }
}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate

extension ResultsSearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    switch viewModel?.state {
    case .history(let sections):
      return sections.count

    case .results(let sections):
      return sections.count

    case .none:
      return 0
    }
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch viewModel?.state {
    case .history(let sections):
      switch sections[section] {
      case .titleRecentlySearched:
        return 1

      case .recentlySearched(let model):
        return model.count
      }

    case .results(let sections):
      switch sections[section] {
      case .didNotFindTheWine:
        return 1

      case .searchResults(let model):
        return model.count
      }

    case .none:
      return 0
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    switch viewModel?.state {
    case .history(let sections):
      switch sections[indexPath.section] {
      case .recentlySearched(let model):
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WineCollectionViewCell.reuseId, for: indexPath) as! WineCollectionViewCell
        cell.decorate(model: model[indexPath.row])
        return cell

      case .titleRecentlySearched(let model):
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCollectionCell.reuseId, for: indexPath) as! TextCollectionCell
        cell.decorate(model: model[indexPath.row])
        return cell
      }

    case .results(let sections):
      switch sections[indexPath.section] {
      case .didNotFindTheWine(let model):
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DidnotFindTheWineCollectionCell.reuseId, for: indexPath) as! DidnotFindTheWineCollectionCell
        cell.delegate = didnotFindTheWineCollectionCellDelegate
        cell.decorate(model: model[indexPath.row])
        return cell

      case .searchResults(let model):
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WineCollectionCell.reuseId, for: indexPath) as! WineCollectionCell
        cell.decorate(model: model[indexPath.row])
        return cell
      }

    case .none:
      return .init()
    }
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch viewModel?.state {
    case .results(let sections):
      switch sections[safe: indexPath.section] {
      case .searchResults(let model):
        let wineID = model[indexPath.row].wineID
        interactor?.didSelectResultCell(wineID: wineID, title: model[indexPath.row].titleText)
        resultsSearchDelegate?.didTapBottleCell(wineID: wineID)

      case .didNotFindTheWine, .none:
        return
      }

    case .history(let sections):
      switch sections[safe: indexPath.section] {
      case .recentlySearched(let model):
        let wineID = model[indexPath.row].wineID
        guard let titleText = model[indexPath.row].titleText else {
          return
        }
        interactor?.didSelectResultCell(wineID: wineID, title: titleText)
        resultsSearchDelegate?.didTapBottleCell(wineID: wineID)

      case .none, .titleRecentlySearched:
        return
      }

    case .none:
      return
    }
  }
}

// MARK: UISearchBarDelegate

extension ResultsSearchViewController: UISearchBarDelegate {

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    collectionView.contentOffset = .zero
    dismiss(animated: true)
  }

  func searchBar(
    _: UISearchBar,
    textDidChange searchText: String)
  {
    interactor?.didEnterSearchText(searchText)
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    resultsSearchDelegate?.didTapSearchButton(searchText: searchBar.text)
  }
}
