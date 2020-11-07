//
//  AdvancedSearchViewController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 05.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import CommonUI

final class AdvancedSearchViewController: UIViewController {

  // MARK: - Internal Properties
  
  var interactor: AdvancedSearchInteractorProtocol?

  // MARK: - Private Properties

  private var contentOffsets: [CGPoint] = []
  private var viewModel: AdvancedSearchViewModel?

  private lazy var layout = UICollectionViewCompositionalLayout { [weak self] (sectionNumber, _) -> NSCollectionLayoutSection? in
    guard let self = self else { return nil }
    switch self.viewModel?.sections[sectionNumber] {
    case .carusel:
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                       heightDimension: .absolute(100)),
                                                     subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      //        section.boundarySupplementaryItems = [.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: categoryHeaderID, alignment: .topLeading),
      //                                              .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20)), elementKind: categorySeparatorID, alignment: .bottom)]
      //        if self.filters.count - 1 == sectionNumber {
      //          section.boundarySupplementaryItems.removeLast()
      //        }

      return section

    case .none:
      return nil
    }
  }

  private lazy var collectionView: UICollectionView = {

    let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
    collectionView.delaysContentTouches = false
    collectionView.backgroundColor = .mainBackground
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(AdvancedSearchCaruselCollectionCell.self)
    //    collectionView.register(AdvancedHeader.self, forSupplementaryViewOfKind: categoryHeaderID, withReuseIdentifier: AdvancedHeader.reuseId)
    //    collectionView.register(SeparatorFooter.self, forSupplementaryViewOfKind: categorySeparatorID, withReuseIdentifier: SeparatorFooter.reuseId)
    return collectionView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(collectionView)
    interactor?.viewDidLoad()
  }
}

// MARK: - AdvancedSearchViewControllerProtocol

extension AdvancedSearchViewController: AdvancedSearchViewControllerProtocol {
  func updateUI(viewModel: AdvancedSearchViewModel, sec: Int?) {
    self.viewModel = viewModel
    if let sec = sec {
      switch viewModel.sections[sec] {
      case .carusel(_, let items):
        let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: sec)) as! AdvancedSearchCaruselCollectionCell // swiftlint:disable:this force_cast
        let model = items[0]
        cell.decorate(model: model)
        cell.setContentOffset(contentOffsets[sec])
      }
    } else {
      collectionView.reloadData()
    }
  }
}

extension AdvancedSearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {

  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int)
    -> Int {

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

    if viewModel.sections.count != contentOffsets.count {
      contentOffsets.append(.zero)
    }

    switch viewModel.sections[indexPath.section] {

    case .carusel(_, let items):
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: AdvancedSearchCaruselCollectionCell.reuseId,
        for: indexPath) as! AdvancedSearchCaruselCollectionCell // swiftlint:disable:this force_cast

      let model = items[indexPath.row]
      cell.setContentOffset(contentOffsets[safe: indexPath.section] ?? .zero)
      cell.decorate(model: model)
      cell.delegate = self
      cell.section = indexPath.section
      return cell
    }
  }
}

extension AdvancedSearchViewController: AdvancedSearchCaruselCollectionCellDelegate {

  func setContentOffset(_ offset: CGPoint, at section: Int) {
    contentOffsets[section] = offset
  }

  func didSelectItem(at indexPath: IndexPath) {
    interactor?.didSelectItem(at: indexPath)
  }
}
