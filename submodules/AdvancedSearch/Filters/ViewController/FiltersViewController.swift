//
//  FiltersViewController.swift
//  AdvancedSearch
//
//  Created by Алексей Смирнов on 01.02.2022.
//

import DisplayMini
import EpoxyBars
import EpoxyCollectionView
import UIKit

// MARK: - FiltersViewController

final class FiltersViewController: CollectionViewController {

  // MARK: Lifecycle

  init() {
    let layout = UICollectionViewFlowLayout()
    super.init(layout: layout)
  }

  // MARK: Internal

  var interactor: FiltersInteractorProtocol?

  override func viewDidLoad() {
    super.viewDidLoad()
//    bottomBarInstaller.install()
    interactor?.viewDidLoad()
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: { _ in
      self.collectionViewSize = size
      self.setSections(self.sections, animated: false)
    })
  }

//  override func makeCollectionView() -> CollectionView {
//    let collectionView = CollectionView(layout: layout, configuration: .init(
//      usesBatchUpdatesForAllReloads: true, usesCellPrefetching: false, usesAccurateScrollToItem: true))
//    return collectionView
//  }

  // MARK: Private

  private var viewModel: FiltersViewModel = .empty

  private lazy var collectionViewSize: CGSize = view.frame.size

  private lazy var bottomBarInstaller = BottomBarInstaller(
    viewController: self,
    bars: bars)

  @SectionModelBuilder
  private var sections: [SectionModel] {
    viewModel.sections.compactMap { section in
      switch section {
      case .title(let content):
        let width: CGFloat = collectionViewSize.width - 48
        let style = Label.Style(font: Font.bold(22), showLabelBackground: true)
        let height: CGFloat = Label.height(
          for: content,
          width: width,
          style: style)
        return SectionModel(dataID: UUID()) {
          Label.itemModel(
            dataID: UUID(),
            content: content,
            style: style)
        }
        .flowLayoutItemSize(.init(width: width, height: height))
        .flowLayoutSectionInset(.init(top: 0, left: 24, bottom: 8, right: 24))

      case .carousel(let str, let content):
        let height: CGFloat = 100
        return SectionModel(dataID: str + "SectionModel") {
          ServingTipsCollectionView.itemModel(
            dataID: str + "ServingTipsCollectionView",
            content: content,
            behaviors: .init(
              didTap: { [weak self] item, view in
                self?.interactor?.didSelect(item: item)
                view.setSelected(flag: self?.interactor?.isSelected(item: item) ?? false, animated: true)
                HapticEffectHelper.vibrate(withEffect: .medium)
              },
              willDisplay: { [weak self] item, view in
                view.setSelected(flag: self?.interactor?.isSelected(item: item) ?? false, animated: false)
              }),
            style: .init(id: UUID()))
        }
        .flowLayoutItemSize(.init(width: collectionViewSize.width, height: height))
        .flowLayoutSectionInset(.init(top: 0, left: 0, bottom: 16, right: 0))

      case .countryTitle(let content):
        let width: CGFloat = collectionViewSize.width - 48
        let height: CGFloat = TitleAndMoreView.height(
          width: width,
          content: content)
        return SectionModel(dataID: UUID()) {
          TitleAndMoreView.itemModel(
            dataID: UUID(),
            content: content,
            behaviors: .init(didTap: { [weak self] in
              self?.interactor?.didTapSeeAllCounties()
            }),
            style: .init())
        }
        .flowLayoutItemSize(.init(width: width, height: height))
        .flowLayoutSectionInset(.init(top: 0, left: 24, bottom: 8, right: 24))
      }
    }
  }

  @BarModelBuilder
  private var bars: [BarModeling] {
    if let content = viewModel.bottomBarViewModel {
      [
        BottomButtonsView.barModel(
          dataID: nil,
          content: content,
          style: .init())
          .setBehaviors({ [weak self] context in
            guard let self = self else { return }
            context.view.delegate = self
          }),
      ]
    } else {
      []
    }
  }
}

// MARK: FiltersViewControllerProtocol

extension FiltersViewController: FiltersViewControllerProtocol {
  func updateUI(viewModel: FiltersViewModel, reloadingData: Bool) {
    self.viewModel = viewModel
    navigationItem.title = viewModel.navigationTitleText
    if reloadingData {
      setSections(sections, animated: false)
    } else {
      collectionView.reloadData()
    }
    bottomBarInstaller.install()
    bottomBarInstaller.setBars(bars, animated: true)
  }
}

// MARK: BottomButtonsViewDelegate

extension FiltersViewController: BottomButtonsViewDelegate {

  func didTapLeadingButton(_ button: UIButton) {
    interactor?.didTapResetAllFilters()
  }

  func didTapTrailingButton(_ button: UIButton) {
    interactor?.didTapConfirmFilters()
  }
}
