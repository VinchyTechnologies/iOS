//
//  StoresViewController.swift
//  Smart
//
//  Created by Михаил Исаченко on 08.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Database
import Display
import DisplayMini
import EpoxyBars
import EpoxyCollectionView
import EpoxyCore
import StringFormatting
import UIKit

// MARK: - C

fileprivate enum C {
  static let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .default)
}

// MARK: - StoresViewController

final class StoresViewController: CollectionViewController {

  // MARK: Lifecycle

  init() {
    super.init(layout: UICollectionViewFlowLayout())
  }

  // MARK: Internal

  var interactor: StoresInteractorProtocol?
  private(set) var loadingIndicator = ActivityIndicatorView()

  lazy var bottomBarInstaller = BottomBarInstaller(
    viewController: self,
    bars: bars)

  @BarModelBuilder
  var bars: [BarModeling] {
    []
  }

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

    collectionView.backgroundColor = .mainBackground
    collectionView.delaysContentTouches = false
    collectionView.scrollDelegate = self
    collectionView.contentInset = .init(top: 0, left: 0, bottom: 10, right: 0)
    bottomBarInstaller.install()
    interactor?.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    interactor?.viewWillAppear()
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: { _ in
      self.collectionViewSize = size
      self.setSections(self.sections, animated: false)
    })
  }

  // MARK: Private

  private var isShaking = false
  private lazy var collectionViewSize: CGSize = view.frame.size

  private var heightBeforeSupplementaryHeader: CGFloat?

  private var supplementaryView: UIView?

  private var viewModel: StoresViewModel = .empty

  @SectionModelBuilder
  private var sections: [SectionModel] {
    viewModel.sections.compactMap { section in
      switch section {
      case .title(let itemID, let content):
        let width: CGFloat = collectionViewSize.width - 48
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
        .flowLayoutSectionInset(.init(top: 0, left: 24, bottom: 16, right: 24))

      case .partners(_, let rows):
        let width = collectionViewSize.width - 48
        return SectionModel(
          dataID: section.dataID,
          items: rows.compactMap({ partnerContent in
            switch partnerContent {
            case .horizontalPartner(let content):
              return HorizontalPartnerView.itemModel(
                dataID: UUID(),
                content: content,
                behaviors: .init(didTapContextMenuDeleteWidget: { [weak self] in
                  self?.interactor?.didTapContextMenuRemoveFromWidget(affilatedId: content.affiliatedStoreId)
                }),
                style: .init())
                .didSelect { [weak self] context in
                  guard let self = self else { return }
                  if self.isShaking {
                    self.interactor?.didTapEditStore(affilatedId: content.affiliatedStoreId)
                  } else {
                    self.interactor?.didSelectPartner(affiliatedStoreId: content.affiliatedStoreId)
                  }
                  if self.interactor?.isUserSelectedPartnerForEditing(affilatedId: content.affiliatedStoreId) == true {
                    context.view.select()
                  } else {
                    context.view.deselect()
                  }
                }
                .willDisplay({ [weak self] context in
                  guard let self = self else { return }
                  if self.isShaking {
                    context.view.shake()
                  } else {
                    context.view.stopShaking()
                  }
                  if self.interactor?.isUserSelectedPartnerForEditing(affilatedId: content.affiliatedStoreId) == true {
                    context.view.select()
                  } else {
                    context.view.deselect()
                  }
                })
                .flowLayoutItemSize(.init(width: collectionViewSize.width - 48, height: content.height(for: width)))
            }
          }))
          .flowLayoutSectionInset(.init(top: 0, left: 24, bottom: 0, right: 24))
          .flowLayoutMinimumLineSpacing(15)

      case .loading(let itemID):
        return SectionModel(dataID: section.dataID) {
          LoadingView.itemModel(dataID: itemID)
        }
        .willDisplay { [weak self] _ in
          self?.interactor?.willDisplayLoadingView()
        }
        .flowLayoutItemSize(.init(width: collectionViewSize.width, height: LoadingView.height))
        .flowLayoutSectionInset(.init(top: 16, left: 0, bottom: 16, right: 0))
      }
    }
  }

  @objc
  private func editWidget() {
    isShaking = true
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: localized("cancel").firstLetterUppercased(), style: .done, target: self, action: #selector(didTapCancelEditing))
    bottomBarInstaller.setBars([
      BottomPriceBarView.barModel(
        dataID: nil,
        content: .init(leadingText: "Добавить в виджет\n(не более 2)", trailingButtonText: "Добавить"),
        behaviors: .init(didSelect: { [weak self] _ in
          guard let self = self else { return }
          self.isShaking = false
          self.bottomBarInstaller.setBars([], animated: true)
          self.interactor?.didTapAddToWidget()

//          self.setSections(self.sections, animated: true) // TODO: -
        }),
        style: .init()),
    ], animated: true)
    setSections(sections, animated: true)
  }

  private func hideErrorView() {
    collectionView.backgroundView = nil
  }

  @objc
  private func didTapCloseBarButtonItem(_: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }

  @objc
  private func didTapCancelEditing() {
    interactor?.didTapCancelEditing()
    isShaking = false
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "pencil", withConfiguration: C.imageConfig), style: .plain, target: self, action: #selector(editWidget))
    bottomBarInstaller.setBars([], animated: true)
    setSections(sections, animated: true)
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

    if viewModel.isEditable {
      navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "pencil", withConfiguration: C.imageConfig), style: .plain, target: self, action: #selector(editWidget))
    } else {
      navigationItem.rightBarButtonItem = nil
    }

    setSections(sections, animated: false)
  }

  func updateUI(errorViewModel: ErrorViewModel) {
    collectionView.setSections([], animated: false)
    let errorView = ErrorView(frame: view.frame)
    errorView.decorate(model: errorViewModel)
    errorView.delegate = self
    collectionView.backgroundView = errorView
  }
}

// MARK: UIScrollViewDelegate

extension StoresViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y > 25 { // TODO: -
      navigationItem.title = viewModel.navigationTitleText
    } else {
      navigationItem.title = nil
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
