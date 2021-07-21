//
//  StoreViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 05.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Database
import Display
import Epoxy
import UIKit

// MARK: - StoreViewController

final class StoreViewController: CollectionViewController {

  // MARK: Lifecycle

  init() {
    let layout = SeparatorFlowLayout()
    layout.sectionHeadersPinToVisibleBounds = true
    super.init(layout: layout)
    layout.delegate = self
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

      .address("Москва, Проспект Вернадского, 16"),

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

      .assortiment(
        header: ["Весь ассортмент"],
        content: [
          .init(wineID: 1, imageURL: imageURL(from: 891).toURL, titleText: "Wine", subtitleText: "Italia"),
          .init(wineID: 1, imageURL: imageURL(from: 891).toURL, titleText: "Wine", subtitleText: "Italia"),
          .init(wineID: 1, imageURL: imageURL(from: 891).toURL, titleText: "Wine", subtitleText: "Italia"),
          .init(wineID: 1, imageURL: imageURL(from: 891).toURL, titleText: "Wine", subtitleText: "Italia"),
          .init(wineID: 1, imageURL: imageURL(from: 891).toURL, titleText: "Wine", subtitleText: "Italia"),
          .init(wineID: 1, imageURL: imageURL(from: 891).toURL, titleText: "Wine", subtitleText: "Italia"),
          .init(wineID: 1, imageURL: imageURL(from: 891).toURL, titleText: "Wine", subtitleText: "Italia"),
          .init(wineID: 1, imageURL: imageURL(from: 891).toURL, titleText: "Wine", subtitleText: "Italia"),
          .init(wineID: 1, imageURL: imageURL(from: 891).toURL, titleText: "Wine", subtitleText: "Italia"),
          .init(wineID: 1, imageURL: imageURL(from: 891).toURL, titleText: "Wine", subtitleText: "Italia"),
          .init(wineID: 1, imageURL: imageURL(from: 891).toURL, titleText: "Wine", subtitleText: "Italia"),
          .init(wineID: 1, imageURL: imageURL(from: 891).toURL, titleText: "Wine", subtitleText: "Italia"),
        ]),

      .loading,
    ])

    updateUI(viewModel: viewModel)
  }

  // MARK: Private

  private enum SectionID {
    case logo, title, wines, winesSection, staticSelectedFilters, separator, assortiment, address, loading
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
        .flowLayoutSectionInset(.init(top: 0, left: 0, bottom: 16, right: 0))
        .flowLayoutItemSize(.init(width: view.frame.width, height: 60))

      case .title(let content):
        let width: CGFloat = view.frame.width - 48
        let height: CGFloat = Label.height(
          for: content,
          width: width,
          style: .style(with: .lagerTitle))
        return SectionModel(dataID: SectionID.title) {
          Label.itemModel(
            dataID: SectionID.title,
            content: content,
            style: .style(with: .lagerTitle))
        }
        .flowLayoutItemSize(.init(width: width, height: height))
        .flowLayoutSectionInset(.init(top: 0, left: 24, bottom: 8, right: 24))

      case .address(let content):
        let width: CGFloat = view.frame.width - 48
        let height: CGFloat = Label.height(
          for: content,
          width: width,
          style: .style(with: .regular, textColor: .blueGray))
        return SectionModel(dataID: SectionID.address) {
          Label.itemModel(
            dataID: SectionID.address,
            content: content,
            style: .style(with: .regular, textColor: .blueGray))
        }
        .flowLayoutItemSize(.init(width: width, height: height))
        .flowLayoutSectionInset(.init(top: 0, left: 24, bottom: 16, right: 24))

      case .wines(let content):
        return SectionModel(dataID: SectionID.wines) {
          BottlesCollectionView.itemModel(
            dataID: SectionID.winesSection,
            content: content,
            behaviors: .init(didTap: { [weak self] wineID in
              self?.interactor?.didSelectWine(wineID: wineID)
            }),
            style: .init())
        }
        .flowLayoutItemSize(.init(width: view.frame.width, height: 250))
        .flowLayoutSectionInset(.init(top: 0, left: 0, bottom: 16, right: 0))

      case .assortiment(let header, let rows):
        return SectionModel(dataID: SectionID.assortiment, items: rows.enumerated().compactMap({ index, content in
          HorizontalWineView.itemModel(
            dataID: content.wineID + Int64(index),
            content: content,
            style: .init())
            .didSelect { [weak self] _ in
              self?.interactor?.didSelectWine(wineID: content.wineID)
            }
        }))
          .supplementaryItems(ofKind: UICollectionView.elementKindSectionHeader, [
            FiltersCollectionView.supplementaryItemModel(
              dataID: SectionID.staticSelectedFilters,
              content: header,
              style: .init()),
          ])
          .flowLayoutHeaderReferenceSize(.init(width: view.frame.width, height: 50))
          .flowLayoutItemSize(.init(width: view.frame.width, height: 130))

      case .loading:
        return SectionModel(dataID: SectionID.loading) {
          LoadingView.itemModel(dataID: SectionID.loading)
        }
        .flowLayoutItemSize(.init(width: view.frame.width, height: 48))
        .flowLayoutSectionInset(.init(top: 16, left: 0, bottom: 16, right: 0))
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

// MARK: SeparatorFlowLayoutDelegate

extension StoreViewController: SeparatorFlowLayoutDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: SeparatorFlowLayout,
    shouldShowSeparatorBelowItemAt indexPath: IndexPath)
    -> Bool
  {
    switch viewModel.sections[indexPath.section] {
    case .logo, .title, .wines, .address, .loading:
      return false

    case .assortiment:
      return true
    }
  }
}
