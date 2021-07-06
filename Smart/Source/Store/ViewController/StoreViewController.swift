//
//  StoreViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 05.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Database
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

      .title("Vinchy recommends"),

      .wines([
        .init(wineID: 1, imageURL: imageURL(from: 891).toURL, titleText: "Wine", subtitleText: "Italia"),
        .init(wineID: 1, imageURL: imageURL(from: 891).toURL, titleText: "Wine", subtitleText: "Italia"),
        .init(wineID: 1, imageURL: imageURL(from: 891).toURL, titleText: "Wine", subtitleText: "Italia"),
        .init(wineID: 1, imageURL: imageURL(from: 891).toURL, titleText: "Wine", subtitleText: "Italia"),
        .init(wineID: 1, imageURL: imageURL(from: 891).toURL, titleText: "Wine", subtitleText: "Italia"),
        .init(wineID: 1, imageURL: imageURL(from: 891).toURL, titleText: "Wine", subtitleText: "Italia"),
        .init(wineID: 1, imageURL: imageURL(from: 891).toURL, titleText: "Wine", subtitleText: "Italia"),
      ]),

      .assortiment([
        .init(wineID: 1, imageURL: imageURL(from: 891).toURL, titleText: "Wine", subtitleText: "Italia"),
        .init(wineID: 1, imageURL: imageURL(from: 891).toURL, titleText: "Wine", subtitleText: "Italia"),
        .init(wineID: 1, imageURL: imageURL(from: 891).toURL, titleText: "Wine", subtitleText: "Italia"),
        .init(wineID: 1, imageURL: imageURL(from: 891).toURL, titleText: "Wine", subtitleText: "Italia"),
        .init(wineID: 1, imageURL: imageURL(from: 891).toURL, titleText: "Wine", subtitleText: "Italia"),
        .init(wineID: 1, imageURL: imageURL(from: 891).toURL, titleText: "Wine", subtitleText: "Italia"),
        .init(wineID: 1, imageURL: imageURL(from: 891).toURL, titleText: "Wine", subtitleText: "Italia"),
      ]),
    ])
    updateUI(viewModel: viewModel)
  }

  // MARK: Private

  private enum SectionID {
    case logo, title, wines
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

    case .title:
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(15)))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(15)), subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = .init(top: 10, leading: 24, bottom: 0, trailing: 24)
      return section

    case .wines:
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(150), heightDimension: .absolute(250)))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(150), heightDimension: .absolute(250)), subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      section.interGroupSpacing = 8
      section.orthogonalScrollingBehavior = .continuous
      section.contentInsets = .init(top: 10, leading: 24, bottom: 0, trailing: 24)
      return section

    case .assortiment:
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: UIDevice.current.userInterfaceIdiom == .pad ? .fractionalWidth(0.33) : .fractionalWidth(0.5), heightDimension: .absolute(250)))
      item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 8)
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(250)), subitems: [item, item])
      let section = NSCollectionLayoutSection(group: group)
      section.interGroupSpacing = 8
      section.contentInsets = .init(top: 10, leading: 16, bottom: 0, trailing: 8)
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

      case .title(let content):
        return SectionModel(dataID: SectionID.logo) {
          Label.itemModel(
            dataID: SectionID.title,
            content: content,
            style: .style(with: .lagerTitle))
        }

      case .wines(let rows):
        return SectionModel(dataID: SectionID.wines, items: rows.compactMap({ content in
          WineBottleView.itemModel(
            dataID: content.wineID,
            content: content,
            style: .init())
        }))

      case .assortiment(let rows):
        return SectionModel(dataID: SectionID.wines, items: rows.compactMap({ content in
          WineBottleView.itemModel(
            dataID: content.wineID,
            content: content,
            style: .init())
        }))
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
