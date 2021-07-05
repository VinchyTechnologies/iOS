//
//  StoreViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 05.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Epoxy
import UIKit

// MARK: - StoreViewController

final class StoreViewController: CollectionViewController {

  // MARK: Lifecycle

  init() {
    super.init(layout: UICollectionViewCompositionalLayout.epoxy)
  }

  // MARK: Internal

  var interactor: StoreInteractorProtocol?

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.collectionViewLayout = compositionalLayout
    interactor?.viewDidLoad()
    let viewModel = StoreViewModel(sections: [
      .logo(
        LogoRow.Content(
          id: 1,
          title: "x5Group",
          logoURL: "https://buninave.ru/wp-content/uploads/2018/05/logo_5ka.png")),
    ])
    updateUI(viewModel: viewModel)
  }

  // MARK: Private

  private enum SectionID {
    case logo
  }

  private lazy var compositionalLayout = UICollectionViewCompositionalLayout { [weak self] sectionNumber, _ -> NSCollectionLayoutSection? in

    guard let self = self else { return nil }

    guard let type = self.viewModel.sections[safe: sectionNumber] else {
      return nil
    }

    switch type {
    case .logo:
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(15)))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(15)), subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      return section
    }
  }

  private var viewModel: StoreViewModel = .empty

  @SectionModelBuilder
  private var sections: [SectionModel] {
    viewModel.sections.compactMap { section in
      switch section {
      case .logo(let content):
        return SectionModel(dataID: SectionID.logo) {
          LogoRow.itemModel(
            dataID: SectionID.logo,
            content: content,
            style: .large)
        }
      }
    }
  }
}

// MARK: StoreViewControllerProtocol

extension StoreViewController: StoreViewControllerProtocol {
  func updateUI(viewModel: StoreViewModel) {
    self.viewModel = viewModel
    setSections(sections, animated: true)
  }
}
