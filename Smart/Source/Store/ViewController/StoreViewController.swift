//
//  StoreViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 05.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI
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

  private(set) var loadingIndicator = ActivityIndicatorView()
  var interactor: StoreInteractorProtocol?

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.largeTitleDisplayMode = .never

    collectionView.delaysContentTouches = false
    collectionView.scrollDelegate = self

    let filterBarButtonItem = UIBarButtonItem(
      image: UIImage(named: "edit")?.withRenderingMode(.alwaysTemplate),
      style: .plain,
      target: self,
      action: nil)
    navigationItem.rightBarButtonItems = [filterBarButtonItem]

    interactor?.viewDidLoad()
  }

  // MARK: Private

  private var supplementaryView: UIView?
  private var heightBeforeSupplementaryHeader: CGFloat?
  private var viewModel: StoreViewModel = .empty

  @SectionModelBuilder
  private var sections: [SectionModel] {
    viewModel.sections.compactMap { section in
      switch section {
      case .logo(let itemID, let content):
        let width = view.frame.width - 48
        return SectionModel(dataID: section.dataID) {
          LogoRow.itemModel(
            dataID: itemID,
            content: content,
            style: .large)
        }
        .flowLayoutSectionInset(.init(top: 0, left: 0, bottom: 16, right: 0))
        .flowLayoutItemSize(.init(width: view.frame.width, height: content.height(for: width)))

      case .title(let itemID, let content):
        let width: CGFloat = view.frame.width - 48
        let height: CGFloat = Label.height(
          for: content,
          width: width,
          style: .style(with: .lagerTitle))
        return SectionModel(dataID: section.dataID) {
          Label.itemModel(
            dataID: itemID,
            content: content,
            style: .style(with: .lagerTitle))
        }
        .flowLayoutItemSize(.init(width: width, height: height))
        .flowLayoutSectionInset(.init(top: 0, left: 24, bottom: 8, right: 24))

      case .address(let itemID, let content):
        let width: CGFloat = view.frame.width - 48
        let height: CGFloat = Label.height(
          for: content,
          width: width,
          style: .style(with: .regular, textColor: .blueGray))
        return SectionModel(dataID: section.dataID) {
          Label.itemModel(
            dataID: itemID,
            content: content,
            style: .style(with: .regular, textColor: .blueGray))
        }
        .flowLayoutItemSize(.init(width: width, height: height))
        .flowLayoutSectionInset(.init(top: 0, left: 24, bottom: 16, right: 24))

      case .wines(let itemID, let content):
        return SectionModel(dataID: section.dataID) {
          BottlesCollectionView.itemModel(
            dataID: itemID,
            content: content,
            behaviors: .init(didTap: { [weak self] wineID in
              self?.interactor?.didSelectWine(wineID: wineID)
            }),
            style: .init())
        }
        .flowLayoutItemSize(.init(width: view.frame.width, height: 250))
        .flowLayoutSectionInset(.init(top: 0, left: 0, bottom: 16, right: 0))

      case .assortiment(let headerItemID, let header, let rows):
        return SectionModel(
          dataID: section.dataID,
          items: rows.enumerated().compactMap({ index, assortmentContent in
            switch assortmentContent {
            case .horizontalWine(let content):
              return HorizontalWineView.itemModel(
                dataID: content.wineID + Int64(index),
                content: content,
                style: .init())
                .didSelect { [weak self] _ in
                  self?.interactor?.didSelectWine(wineID: content.wineID)
                }
                .flowLayoutItemSize(.init(width: view.frame.width, height: 130))

            case .ad(let itemID):
              return AdItemView.itemModel(
                dataID: itemID.rawValue + String(index),
                content: .init(),
                style: .init())
                .setBehaviors { [weak self] context in
                  context.view.adBanner.rootViewController = self
                }
                .flowLayoutItemSize(.init(width: view.frame.width, height: AdItemView.height))
            }
          }))
          .supplementaryItems(ofKind: UICollectionView.elementKindSectionHeader, [
            FiltersCollectionView.supplementaryItemModel(
              dataID: headerItemID,
              content: header,
              style: .init())
              .setBehaviors { [weak self] context in
                self?.supplementaryView = context.view
              },
          ])
          .flowLayoutHeaderReferenceSize(.init(width: view.frame.width, height: 50))

      case .loading(let itemID):
        return SectionModel(dataID: section.dataID) {
          LoadingView.itemModel(dataID: itemID)
        }
        .willDisplay { [weak self] _ in
          self?.interactor?.willDisplayLoadingView()
        }
        .flowLayoutItemSize(.init(width: view.frame.width, height: LoadingView.height))
        .flowLayoutSectionInset(.init(top: 16, left: 0, bottom: 16, right: 0))
      }
    }
  }

  private func updateShadowSupplementaryHeaderView(offset: CGFloat) {
    if let heightBeforeSupplementaryHeader = heightBeforeSupplementaryHeader {
      let value: CGFloat = offset - heightBeforeSupplementaryHeader + 50
      let alpha = min(1, max(0, value / 10))
      supplementaryView?.layer.shadowOpacity = Float(alpha / 2.0)
    }
  }

  private func hideErrorView() {
    collectionView.backgroundView = nil
  }
}

// MARK: StoreViewControllerProtocol

extension StoreViewController: StoreViewControllerProtocol {

  func updateUI(errorViewModel: ErrorViewModel) {
    let errorView = ErrorView(frame: view.frame)
    errorView.decorate(model: errorViewModel)
    errorView.delegate = self
    collectionView.backgroundView = errorView
  }

  func updateUI(viewModel: StoreViewModel) {
    hideErrorView()

    self.viewModel = viewModel

    if heightBeforeSupplementaryHeader == nil {
      var resultHeight: CGFloat = 0.0
      viewModel.sections.forEach { section in
        switch section {
        case .logo(_, let content):
          let width = view.frame.width - 48
          let height = content.height(for: width)
          resultHeight += height + 16

        case .title(_, let content):
          let width: CGFloat = view.frame.width - 48
          let height: CGFloat = Label.height(
            for: content,
            width: width,
            style: .style(with: .lagerTitle))
          resultHeight += height + 8

        case .address(_, let content):
          let width: CGFloat = view.frame.width - 48
          let height: CGFloat = Label.height(
            for: content,
            width: width,
            style: .style(with: .regular, textColor: .blueGray))
          resultHeight += height + 16

        case .wines:
          resultHeight += 250 + 16

        case .assortiment, .loading:
          resultHeight += 0
        }
      }

      heightBeforeSupplementaryHeader = resultHeight
    }

    setSections(sections, animated: false)
  }
}

// MARK: UIScrollViewDelegate

extension StoreViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y > 50 { // TODO: -
      navigationItem.title = viewModel.navigationTitleText
    } else {
      navigationItem.title = nil
    }

    if heightBeforeSupplementaryHeader != nil {
      updateShadowSupplementaryHeaderView(offset: scrollView.contentOffset.y)
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

// MARK: ErrorViewDelegate

extension StoreViewController: ErrorViewDelegate {
  func didTapErrorButton(_ button: UIButton) {
    interactor?.didTapReloadButton()
  }
}

// MARK: Loadable

extension StoreViewController: Loadable {
  func startLoadingAnimation() {
    hideErrorView()
    loadingIndicator.isAnimating = true
  }
}
