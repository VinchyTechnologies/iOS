//
//  StoreViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 05.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core
import Database
import DisplayMini
import EpoxyCollectionView
import EpoxyCore
import EpoxyLayoutGroups
import UIKit
import VinchyUI

// MARK: - StoreViewController

final class StoreViewController: CollectionViewController {

  // MARK: Lifecycle

  init(adGenerator: AdFabricProtocol?) {
    self.adGenerator = adGenerator
    let layout = SeparatorFlowLayout()
    layout.sectionHeadersPinToVisibleBounds = true
    super.init(layout: layout)
    layout.delegate = self
  }

  // MARK: Internal

  private(set) var loadingIndicator = ActivityIndicatorView()
  var interactor: StoreInteractorProtocol?

  override func makeCollectionView() -> CollectionView {
    let collectionView = CollectionView(
      layout: layout,
      configuration: .init(
        usesBatchUpdatesForAllReloads: false,
        usesCellPrefetching: false,
        usesAccurateScrollToItem: true))
    collectionView.prefetchDelegate = self
    return collectionView
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .mainBackground
    collectionView.backgroundColor = .mainBackground

    navigationItem.largeTitleDisplayMode = .never

    if isModal {
      let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .default)
      navigationItem.leftBarButtonItem = UIBarButtonItem(
        image: UIImage(systemName: "chevron.down", withConfiguration: imageConfig),
        style: .plain,
        target: self,
        action: #selector(didTapCloseBarButtonItem(_:)))
    }

    collectionView.delaysContentTouches = false
    collectionView.scrollDelegate = self

    let filterBarButtonItem = UIBarButtonItem(
      image: UIImage(named: "edit")?.withRenderingMode(.alwaysOriginal).withTintColor(.dark),
      style: .plain,
      target: self,
      action: #selector(didTapFilterButton(_:)))

    let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium, scale: .default)
    let searchBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "magnifyingglass", withConfiguration: imageConfig),
      style: .plain,
      target: self,
      action: #selector(didTapSearchButton(_:)))
    navigationItem.rightBarButtonItems = [filterBarButtonItem, searchBarButtonItem]

    interactor?.viewDidLoad()
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: { _ in
      self.collectionViewSize = size
      self.setSections(self.sections, animated: false)
    })
  }

  // MARK: Private

  private let adGenerator: AdFabricProtocol?
  private lazy var collectionViewSize: CGSize = view.frame.size

  private var supplementaryView: UIView?
  private var heightBeforeSupplementaryHeader: CGFloat?
  private var viewModel: StoreViewModel = .empty

  @SectionModelBuilder
  private var sections: [SectionModel] {
    viewModel.sections.compactMap { section in
      switch section {
      case .logo(let itemID, let content):
        let width = collectionViewSize.width - 48
        return SectionModel(dataID: UUID()) {
          LogoRow.itemModel(
            dataID: UUID(),
            content: content,
            style: .large)
        }
        .flowLayoutSectionInset(.init(top: 0, left: 0, bottom: 8, right: 0))
        .flowLayoutItemSize(.init(width: collectionViewSize.width, height: content.height(for: width)))

      case .title(let itemID, let content):
        let width: CGFloat = collectionViewSize.width - 48
        let height: CGFloat = Label.height(
          for: content,
          width: width,
          style: .style(with: .lagerTitle))
        return SectionModel(dataID: UUID()) {
          Label.itemModel(
            dataID: UUID(),
            content: content,
            style: .style(with: .lagerTitle))
        }
        .flowLayoutItemSize(.init(width: width, height: height))
        .flowLayoutSectionInset(.init(top: 0, left: 24, bottom: 8, right: 24))

      case .address(let itemID, let content):
        let width: CGFloat = collectionViewSize.width - 48
        let height: CGFloat = content.height(for: width)
        return SectionModel(dataID: UUID()) {
          StoreMapRow.itemModel(
            dataID: UUID(),
            content: content,
            behaviors: .init(didTapMap: { [weak self] button in
              self?.interactor?.didTapMapButton(button: button)
            }),
            style: .init())
        }
        .flowLayoutItemSize(.init(width: width, height: height))
        .flowLayoutSectionInset(.init(top: 0, left: 24, bottom: 16, right: 24))

      case .services(let content):
        let width: CGFloat = collectionViewSize.width - 48
        let height: CGFloat = content.height(for: width)
        return SectionModel(dataID: UUID()) {
          ServicesButtonView.itemModel(
            dataID: UUID(),
            content: content,
            behaviors: .init(didTapLike: { [weak self] _ in
              self?.interactor?.didTapLikeButton()
            }),
            style: .init())
            .willDisplay { [weak self] context in
              guard let self = self else { return }
              context.view.likeButton.isSelected = self.viewModel.isLiked
            }
        }
        .flowLayoutItemSize(.init(width: width, height: height))
        .flowLayoutSectionInset(.init(top: 0, left: 24, bottom: 16, right: 24))

      case .wines(let itemID, let content):
        return SectionModel(dataID: UUID()) {
          BottlesCollectionView.itemModel(
            dataID: UUID(),
            content: content,
            style: .init())
            .setBehaviors({ [weak self] context in
              context.view.bottlesCollectionViewDelegate = self
            })
        }
        .flowLayoutItemSize(.init(width: collectionViewSize.width, height: 250))
        .flowLayoutSectionInset(.init(top: 0, left: 0, bottom: 16, right: 0))

      case .assortiment(let headerItemID, let header, let rows):
        return SectionModel(
          dataID: UUID(),
          items: rows.compactMap({ assortmentContent in
            switch assortmentContent {
            case .horizontalWine(let content):
              return HorizontalWineView.itemModel(
                dataID: UUID(),
                content: content,
                behaviors: .init(didTap: { [weak self] _, wineID in
                  self?.interactor?.didTapHorizontalWineViewButton(wineID: wineID)
                }),
                style: .init(kind: .common))
                .didSelect { [weak self] _ in
                  self?.interactor?.didSelectWine(wineID: content.wineID)
                }
                .flowLayoutItemSize(.init(width: collectionViewSize.width, height: content.height(width: collectionViewSize.width)))

            case .contentCoulBeNotRight(let content):
              let width: CGFloat = collectionViewSize.width - 48
              let height: CGFloat = Label.height(
                for: content,
                width: width,
                style: .style(with: .miniBold, textAligment: .center))
              return Label.itemModel(
                dataID: UUID(),
                content: content,
                style: .style(with: .miniBold, textAligment: .center))
                .flowLayoutItemSize(.init(width: width, height: height))

            case .ad(let itemID):
              if let adGenerator = adGenerator {
                return adGenerator.generateGoogleAd(width: collectionViewSize.width, rootcontroller: self) as? ItemModeling
              } else {
                return nil
              }

            case .empty(let itemID, let content):
              return EmptyView.itemModel(
                dataID: UUID(),
                content: content,
                style: .init())
                .flowLayoutItemSize(.init(width: collectionViewSize.width, height: 250)) // TODO: - height
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
          .flowLayoutHeaderReferenceSize(.init(width: collectionViewSize.width, height: 50))

      case .loading(let itemID, let shouldCallWillDisplay):
        return SectionModel(dataID: UUID()) {
          LoadingView.itemModel(dataID: UUID())
        }
        .willDisplay { [weak self] _ in
          if shouldCallWillDisplay {
            self?.interactor?.willDisplayLoadingView()
          }
        }
        .flowLayoutItemSize(.init(width: collectionViewSize.width, height: LoadingView.height))
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

  @objc
  private func didTapCloseBarButtonItem(_: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }

  @objc
  private func didTapFilterButton(_ button: UIBarButtonItem) {
    interactor?.didTapFilterButton()
  }

  @objc
  private func didTapSearchButton(_ button: UIBarButtonItem) {
    interactor?.didTapSearchButton()
  }
}

// MARK: StoreViewControllerProtocol

extension StoreViewController: StoreViewControllerProtocol {

  func setLikedStatus(isLiked: Bool) {
    viewModel.isLiked = isLiked
  }

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
          let width = collectionViewSize.width - 48
          let height = content.height(for: width)
          resultHeight += height + 8

        case .title(_, let content):
          let width: CGFloat = collectionViewSize.width - 48
          let height: CGFloat = Label.height(
            for: content,
            width: width,
            style: .style(with: .lagerTitle))
          resultHeight += height + 8

        case .address(_, let content):
          let width: CGFloat = collectionViewSize.width - 48
          let height: CGFloat = content.height(for: width)
          resultHeight += height + 16

        case .wines:
          resultHeight += 250 + 16

        case .assortiment, .loading:
          resultHeight += 0

        case .services(let content):
          let width: CGFloat = collectionViewSize.width - 48
          resultHeight += content.height(for: width)
        }
      }

      heightBeforeSupplementaryHeader = resultHeight
    }

    if viewModel.shouldResetContentOffset {
      if collectionView.contentOffset.y > 0 {
        let scrollToTopIfPossibleSelector = Selector(encodeText("`tdspmmUpUpqJgQpttjcmf;", -1))
        if (collectionView as UIScrollView).responds(to: scrollToTopIfPossibleSelector) {
          (collectionView as UIScrollView).perform(scrollToTopIfPossibleSelector)
        }
      }
      setSections(sections, animated: false)
    } else {
      setSections(sections, animated: false)
    }
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
    case .logo, .title, .wines, .address, .services, .loading:
      return false

    case .assortiment:
      if indexPath.row == 1 {
        return false
      }
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

// MARK: BottlesCollectionViewDelegate

extension StoreViewController: BottlesCollectionViewDelegate {
  func didTapWriteNoteContextMenu(wineID: Int64) {
    interactor?.didTapWriteNoteContextMenu(wineID: wineID)
  }

  func didTap(wineID: Int64) {
    interactor?.didSelectWine(wineID: wineID)
  }

  func didTapShareContextMenu(wineID: Int64, sourceView: UIView) {
    interactor?.didTapShareContextMenu(wineID: wineID, sourceView: sourceView)
  }
}

// MARK: CollectionViewPrefetchingDelegate

extension StoreViewController: CollectionViewPrefetchingDelegate {
  func collectionView(_ collectionView: CollectionView, prefetch items: [AnyItemModel]) {
    for item in items {
      if let content = (item.model as? ItemModel<HorizontalWineView>)?.erasedContent as? HorizontalWineView.Content {
        ImageLoader.shared.prefetch(url: content.imageURL)
      }
    }
  }

  func collectionView(_ collectionView: CollectionView, cancelPrefetchingOf items: [AnyItemModel]) {
    for item in items {
      if
        let content = (item.model as? ItemModel<HorizontalWineView>)?.erasedContent as? HorizontalWineView.Content,
        let url = content.imageURL
      {
        ImageLoader.shared.cancelPrefetch([url])
      }
    }
  }
}
