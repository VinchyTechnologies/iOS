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

    collectionView.delaysContentTouches = false
    collectionView.scrollDelegate = self

    navigationItem.largeTitleDisplayMode = .never

    let filterBarButtonItem = UIBarButtonItem(
      image: UIImage(named: "edit")?.withRenderingMode(.alwaysTemplate),
      style: .plain,
      target: self,
      action: nil)
    navigationItem.rightBarButtonItems = [filterBarButtonItem]

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

      .staticSelectedFilters(["Весь ассортимент"]),

      .assortiment([
        .init(wineID: 1, imageURL: imageURL(from: 891).toURL, titleText: "Wine", subtitleText: "Italia"),
      ]),
      .separator,

      .assortiment([
        .init(wineID: 1, imageURL: imageURL(from: 891).toURL, titleText: "Wine", subtitleText: "Italia"),
      ]),
      .separator,

      .assortiment([
        .init(wineID: 1, imageURL: imageURL(from: 891).toURL, titleText: "Wine", subtitleText: "Italia"),
      ]),
      .separator,

      .assortiment([
        .init(wineID: 1, imageURL: imageURL(from: 891).toURL, titleText: "Wine", subtitleText: "Italia"),
      ]),
      .separator,

      .assortiment([
        .init(wineID: 1, imageURL: imageURL(from: 891).toURL, titleText: "Wine", subtitleText: "Italia"),
      ]),
      .separator,

      .assortiment([
        .init(wineID: 1, imageURL: imageURL(from: 891).toURL, titleText: "Wine", subtitleText: "Italia"),
      ]),
      .separator,

      .assortiment([
        .init(wineID: 1, imageURL: imageURL(from: 891).toURL, titleText: "Wine", subtitleText: "Italia"),
      ]),
      .separator,

      .assortiment([
        .init(wineID: 1, imageURL: imageURL(from: 891).toURL, titleText: "Wine", subtitleText: "Italia"),
      ]),
      .separator,

    ])

    updateUI(viewModel: viewModel)
  }

  // MARK: Private

  private enum SectionID {
    case logo, title, wines, staticSelectedFilters, separator, assortiment
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
        .compositionalLayoutSection(sectionLayout(for: section))

      case .title(let content):
        return SectionModel(dataID: SectionID.title) {
          Label.itemModel(
            dataID: SectionID.title,
            content: content,
            style: .style(with: .lagerTitle))
        }
        .compositionalLayoutSection(sectionLayout(for: section))

      case .wines(let rows):
        return SectionModel(dataID: SectionID.wines, items: rows.compactMap({ content in
          WineBottleView.itemModel(
            dataID: content.wineID,
            content: content,
            style: .init())
            .didSelect { [weak self] _ in
              self?.interactor?.didSelectWine(wineID: content.wineID)
            }
        }))
          .compositionalLayoutSection(sectionLayout(for: section))

      case .assortiment(let rows):
        return SectionModel(dataID: SectionID.assortiment, items: rows.compactMap({ content in
          HorizontalWineView.itemModel(
            dataID: content.wineID,
            content: content,
            style: .init())
            .didSelect { [weak self] _ in
              self?.interactor?.didSelectWine(wineID: content.wineID)
            }
        }))
          .compositionalLayoutSection(sectionLayout(for: section))

      case .staticSelectedFilters(let rows):
        return SectionModel(dataID: SectionID.staticSelectedFilters, items: rows.compactMap({ content in
          FilterItemView.itemModel(
            dataID: SectionID.title,
            content: content,
            style: .init())
        }))
          .compositionalLayoutSection(sectionLayout(for: section))

      case .separator:
        return SectionModel(dataID: SectionID.separator) {
          SeparatorView.itemModel(
            dataID: SectionID.logo,
            content: nil,
            style: .init())
        }
        .compositionalLayoutSection(sectionLayout(for: section))
      }
    }
  }

  private func sectionLayout(for type: StoreViewModel.Section) -> NSCollectionLayoutSection? {
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
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)), subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = .init(top: 10, leading: 24, bottom: 0, trailing: 24)
      return section

    case .staticSelectedFilters:
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .estimated(100), heightDimension: .estimated(24)))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(24)), subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      section.interGroupSpacing = 8
      section.orthogonalScrollingBehavior = .continuous
      section.contentInsets = .init(top: 20, leading: 24, bottom: 0, trailing: 24)
      return section

    case .separator:
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(0.8)))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(0.8)), subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = .init(top: 0, leading: 24, bottom: 0, trailing: 0)
      return section
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

// MARK: UIScrollViewDelegate

extension StoreViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y > 50 {
      navigationItem.title = "x5Group"
    } else {
      navigationItem.title = nil
    }
  }
}
