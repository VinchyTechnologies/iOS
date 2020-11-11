//
//  AdvancedSearchViewController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 05.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import CommonUI

fileprivate enum C {
  static let categoryHeaderID = "categoryHeaderID"
  static let categorySeparatorID = "categorySeparatorID"
}

final class AdvancedSearchViewController: UIViewController {

  // MARK: - Internal Properties
  
  var interactor: AdvancedSearchInteractorProtocol?

  // MARK: - Private Properties

  private var viewModel: AdvancedSearchViewModel?

  private lazy var layout = UICollectionViewCompositionalLayout { [weak self] (sectionNumber, _) -> NSCollectionLayoutSection? in

    guard
      let self = self,
      let viewModel = self.viewModel
    else { return nil }

    switch viewModel.sections[sectionNumber] {
    case .carusel:
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                       heightDimension: .absolute(100)),
                                                     subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      section.boundarySupplementaryItems = [
        .init(
          layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(50)),
          elementKind: C.categoryHeaderID,
          alignment: .topLeading),

        .init(
          layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(20)),
          elementKind: C.categorySeparatorID,
          alignment: .bottom)
      ]

      if viewModel.sections.count - 1 == sectionNumber {
        section.boundarySupplementaryItems.removeLast()
      }

      return section
    }
  }

  private lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
    collectionView.delaysContentTouches = false
    collectionView.backgroundColor = .mainBackground
    collectionView.dataSource = self
    collectionView.showsVerticalScrollIndicator = false // TODO - ???

    collectionView.register(AdvancedSearchCaruselCollectionCell.self)

    collectionView.register(
      AdvancedHeader.self,
      forSupplementaryViewOfKind: C.categoryHeaderID,
      withReuseIdentifier: AdvancedHeader.reuseId)

    collectionView.register(
      SeparatorFooter.self,
      forSupplementaryViewOfKind: C.categorySeparatorID,
      withReuseIdentifier: SeparatorFooter.reuseId)

    return collectionView
  }()

  private lazy var bottomButtonsView: BottomButtonsView = {
    let view = BottomButtonsView()
    view.delegate = self
    return view
  }()

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(collectionView)

    view.addSubview(bottomButtonsView)
    bottomButtonsView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      bottomButtonsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      bottomButtonsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      bottomButtonsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])

    interactor?.viewDidLoad()
  }

  override func viewSafeAreaInsetsDidChange() {
    super.viewSafeAreaInsetsDidChange()

    let bottomButtonsViewHeight: CGFloat = 10 + 48 + view.safeAreaInsets.bottom
    bottomButtonsView.heightAnchor.constraint(equalToConstant: bottomButtonsViewHeight).isActive = true

    // TODO: - make better

  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let bottomButtonsViewHeight: CGFloat = 10 + 48 + view.safeAreaInsets.bottom
    collectionView.contentInset.bottom = bottomButtonsViewHeight + 10
  }
}

// MARK: - AdvancedSearchViewControllerProtocol

extension AdvancedSearchViewController: AdvancedSearchViewControllerProtocol {
  func updateUI(viewModel: AdvancedSearchViewModel, sec: Int?) {
    self.viewModel = viewModel
    navigationItem.title = viewModel.navigationTitle
    bottomButtonsView.decorate(model: viewModel.bottomButtonsViewModel)
    if let sec = sec {
      switch viewModel.sections[sec] {
      case .carusel(_, let items):
        let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: sec)) as! AdvancedSearchCaruselCollectionCell // swiftlint:disable:this force_cast
        cell.decorate(model: items[0])
      }
    } else {
      collectionView.reloadData()
    }
  }
}

// MARK: - UICollectionViewDataSource

extension AdvancedSearchViewController: UICollectionViewDataSource {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    guard let viewModel = viewModel else { return 0 }
    return viewModel.sections.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int)
    -> Int
  {
    guard let viewModel = viewModel else { return 0 }
    switch viewModel.sections[section] {
    case .carusel(_, let items):
      return items.count
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell
  {
    guard let viewModel = viewModel else { return .init() }

    switch viewModel.sections[indexPath.section] {
    case .carusel(_, let items):
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: AdvancedSearchCaruselCollectionCell.reuseId,
        for: indexPath) as! AdvancedSearchCaruselCollectionCell // swiftlint:disable:this force_cast

      let model = items[indexPath.row]
      cell.decorate(model: model)
      cell.delegate = self
      cell.section = indexPath.section
      return cell
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath)
    -> UICollectionReusableView
  {
    guard let viewModel = viewModel else { return .init() }

    switch viewModel.sections[indexPath.section] {
    case .carusel(let viewModel, _):
      if kind == C.categoryHeaderID {
        // swiftlint:disable:next force_cast
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: AdvancedHeader.reuseId, for: indexPath) as! AdvancedHeader
        header.decorate(model: viewModel)
        header.section = indexPath.section
        header.delegate = self
        return header
      } else {
        // swiftlint:disable:next force_cast
        let separator = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SeparatorFooter.reuseId, for: indexPath) as! SeparatorFooter
        return separator
      }
    }
  }
}

// MARK: - AdvancedSearchCaruselCollectionCellDelegate

extension AdvancedSearchViewController: AdvancedSearchCaruselCollectionCellDelegate {
  func didSelectItem(at indexPath: IndexPath) {
    interactor?.didSelectItem(at: indexPath)
  }
}

// MARK: - AdvancedHeaderDelegate

extension AdvancedSearchViewController: AdvancedHeaderDelegate {
  func didTapHeader(at section: Int) {
    interactor?.didTapShowAll(at: section)
  }
}

// MARK: - BottomButtonsViewDelegate

extension AdvancedSearchViewController: BottomButtonsViewDelegate {

  func didTapLeadingButton(_ button: UIButton) {
    interactor?.didTapResetAllFiltersButton()
  }

  func didTapTrailingButton(_ button: UIButton) {
    interactor?.didTapConfirmSearchButton()
  }
}
