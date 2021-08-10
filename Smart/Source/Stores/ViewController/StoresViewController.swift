//
//  StoresViewController.swift
//  Smart
//
//  Created by Михаил Исаченко on 08.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Database
import Display
import Epoxy
import UIKit

// MARK: - StoresViewController

final class StoresViewController: CollectionViewController {

  // MARK: Lifecycle

  init() {
    let layout = SeparatorFlowLayout()
    layout.sectionHeadersPinToVisibleBounds = true
    super.init(layout: layout)
    layout.delegate = self
  }

  // MARK: Internal

  var interactor: StoresInteractorProtocol?
  private(set) var loadingIndicator = ActivityIndicatorView()

  override func viewDidLoad() {
    super.viewDidLoad()
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
      image: UIImage(named: "edit")?.withRenderingMode(.alwaysTemplate),
      style: .plain,
      target: self,
      action: nil)
    navigationItem.rightBarButtonItems = [filterBarButtonItem]
    interactor?.viewDidLoad()
  }

  // MARK: Private

  private var heightBeforeSupplementaryHeader: CGFloat?

  private var supplementaryView: UIView?

  private var viewModel: StoresViewModel = .empty

  @SectionModelBuilder
  private var sections: [SectionModel] {
    viewModel.sections.compactMap { section in
      switch section {
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
      case .partners(let itemID, let header, let rows):
        return SectionModel(
          dataID: section.dataID,
          items: rows.enumerated().compactMap({ index, partnerContent in
            switch partnerContent {

            case .horizontalPartner(let content):
              return HorizontalPartnerView.itemModel(
                dataID: content.affiliatedStoreId + index,
                content: content,
                style: .init())
                .didSelect { [weak self] _ in
                  self?.interactor?.didSelectPartner(affiliatedStoreId: content.affiliatedStoreId)
                }
                .flowLayoutItemSize(.init(width: view.frame.width, height: 130))

            }
          }))
          .supplementaryItems(ofKind: UICollectionView.elementKindSectionHeader, [
            FiltersCollectionView.supplementaryItemModel(
              dataID: itemID,
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

  @objc
  private func didTapCloseBarButtonItem(_: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }

}

// MARK: StoresViewControllerProtocol

extension StoresViewController: StoresViewControllerProtocol {
  func updateUI(viewModel: StoresViewModel) {
    hideErrorView()

    self.viewModel = viewModel

    if heightBeforeSupplementaryHeader == nil {
      var resultHeight: CGFloat = 0.0
      viewModel.sections.forEach { section in
        switch section {

        case .title(_, let content):
          let width: CGFloat = view.frame.width - 48
          let height: CGFloat = Label.height(
            for: content,
            width: width,
            style: .style(with: .lagerTitle))
          resultHeight += height + 8

        case .partners, .loading:
          resultHeight += 0
        }
      }

      heightBeforeSupplementaryHeader = resultHeight
    }

    setSections(sections, animated: false)
  }

  func updateUI(errorViewModel: ErrorViewModel) {
    let errorView = ErrorView(frame: view.frame)
    errorView.decorate(model: errorViewModel)
    errorView.delegate = self
    collectionView.backgroundView = errorView
  }
}

// MARK: SeparatorFlowLayoutDelegate

extension StoresViewController: SeparatorFlowLayoutDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: SeparatorFlowLayout,
    shouldShowSeparatorBelowItemAt indexPath: IndexPath)
    -> Bool
  {
    switch viewModel.sections[indexPath.section] {
    case .title, .loading:
      return false

    case .partners:
      return true
    }
  }
}

// MARK: UIScrollViewDelegate

extension StoresViewController: UIScrollViewDelegate {
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

// MARK: ErrorViewDelegate

extension StoresViewController: ErrorViewDelegate {
  func didTapErrorButton(_ button: UIButton) {
    interactor?.didTapReloadButton()
  }
}

// MARK: Loadable

extension StoresViewController: Loadable {
  func startLoadingAnimation() {
    hideErrorView()
    loadingIndicator.isAnimating = true
  }
}
