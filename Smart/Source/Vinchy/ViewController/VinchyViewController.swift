//
//  VinchyViewController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Core
import Display
import Epoxy
import FittedSheets
import StringFormatting
import UIKit
import VinchyCore

// MARK: - C

private enum C {
  static let horizontalInset: CGFloat = 16
}

// MARK: - VinchyViewController

final class VinchyViewController: CollectionViewController {

  // MARK: Lifecycle

  init() {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.scrollDirection = .vertical
    super.init(layout: layout)
  }

  // MARK: Internal

  var interactor: VinchyInteractorProtocol?

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.largeTitleDisplayMode = .never

    filterButton.translatesAutoresizingMaskIntoConstraints = false
    filterButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    filterButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
    filterButton.setImage(UIImage(named: "edit")?.withRenderingMode(.alwaysTemplate), for: [])
    filterButton.imageView?.contentMode = .scaleAspectFit
    filterButton.imageEdgeInsets = UIEdgeInsets(top: 1, left: 1.5, bottom: 1, right: 1.5)
    filterButton.contentEdgeInsets = .init(top: 6, left: 6, bottom: 6, right: 6)
    filterButton.tintColor = .dark
    filterButton.addTarget(self, action: #selector(didTapFilter), for: .touchUpInside)

    let filterBarButtonItem = UIBarButtonItem(customView: filterButton)
    navigationItem.rightBarButtonItem = filterBarButtonItem
    navigationItem.searchController = searchController

    refreshControl.tintColor = .dark
    refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    collectionView.refreshControl = refreshControl
    collectionView.delaysContentTouches = false
    collectionView.keyboardDismissMode = .onDrag

    interactor?.viewDidLoad()
  }
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: { _ in
      self.collectionView.collectionViewLayout.invalidateLayout()
    })
  }

  // MARK: Private

  private let filterButton = UIButton(type: .system)

  private let refreshControl = UIRefreshControl()

  private lazy var searchController: SearchViewController = {
    let searchController = SearchAssembly.assemblyModule()
    (searchController.searchResultsController as? ResultsSearchViewController)?.resultsSearchDelegate = interactor
    return searchController
  }()

//  @SectionModelBuilder
  private var sections: [SectionModel] {
    switch viewModel.state {
    case .fake(let sections):
      return sections.compactMap { section in
        switch section {
        case .stories(_, let content), .title(_, let content), .promo(_, let content), .big(_, let content):
          let width: CGFloat = view.frame.width
          let height: CGFloat = FakeVinchyCollectionCell.height(viewModel: content)
          return SectionModel(dataID: UUID()) {
            FakeVinchyCollectionCell.itemModel(
              dataID: UUID(),
              content: content,
              style: .init())
          }
          .flowLayoutItemSize(.init(width: width, height: height))
          .flowLayoutSectionInset(.init(top: 0, left: C.horizontalInset, bottom: 8, right: C.horizontalInset))
        }
      }

    case .normal(let sections):
      return sections.compactMap { section in
        switch section {
        case .bottles(let content):
          let width: CGFloat = view.frame.width
          let height: CGFloat = 250
          return SectionModel(dataID: UUID()) {
            BottlesCollectionView.itemModel(
              dataID: UUID(),
              content: content,
              style: .init())
              .setBehaviors({ [weak self] context in
                context.view.bottlesCollectionViewDelegate = self
              })
          }
          .flowLayoutItemSize(.init(width: width, height: height))
          .flowLayoutSectionInset(.init(top: 0, left: C.horizontalInset, bottom: 8, right: C.horizontalInset))

        case .title(let content):
          let style: Label.Style = .style(with: TextStyle.lagerTitle)
          let width: CGFloat = view.frame.width - C.horizontalInset * 2
          let height: CGFloat = Label.height(for: content, width: width, style: style)
          return SectionModel(dataID: UUID()) {
            Label.itemModel(
              dataID: UUID(),
              content: content,
              style: style)
          }
          .flowLayoutItemSize(.init(width: width, height: height))
          .flowLayoutSectionInset(.init(top: 0, left: C.horizontalInset, bottom: 8, right: C.horizontalInset))

        case .stories(let content):
          let width: CGFloat = view.frame.width
          let height: CGFloat = 135
          return SectionModel(dataID: UUID()) {
            StoriesCollectionView.itemModel(
              dataID: UUID(),
              content: content,
              style: .init())
          }
          .flowLayoutItemSize(.init(width: width, height: height))
          .flowLayoutSectionInset(.init(top: 0, left: C.horizontalInset, bottom: 8, right: C.horizontalInset))

        case .storeTitle(let content):
          let width: CGFloat = view.frame.width - 2 * C.horizontalInset
          let height: CGFloat = StoreTitleView.height(viewModel: content, for: width)
          return SectionModel(dataID: UUID()) {
            StoreTitleView.itemModel(
              dataID: UUID(),
              content: content,
              style: .init())
          }
          .flowLayoutItemSize(.init(width: width, height: height))
          .flowLayoutSectionInset(.init(top: 0, left: C.horizontalInset, bottom: 8, right: C.horizontalInset))
        }
      }
    }
  }

  private var viewModel: VinchyViewControllerViewModel = .empty {
    didSet {
      UIView.performWithoutAnimation {
        let addressButton = DiscoveryLeadingAddressButton.build(mode: viewModel.leadingAddressButtonViewModel)
        addressButton.addTarget(self, action: #selector(didTapChangeAddressButton(_:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addressButton)
      }

      switch viewModel.state {
      case .fake:
        collectionView.isScrollEnabled = false
        setSections(sections, animated: true)

      case .normal:
        collectionView.isScrollEnabled = true
        setSections(sections, animated: true)
      }
    }
  }

  @objc
  private func didTapChangeAddressButton(_ button: UIButton) {
    interactor?.didTapChangeAddressButton()
  }

  @objc
  private func didTapFilter() {
    interactor?.didTapFilter()
  }

  @objc
  private func didPullToRefresh() {
    interactor?.didPullToRefresh()
  }
}

// MARK: VinchyViewControllerProtocol

//extension VinchyViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//  func collectionView(
//    _ collectionView: UICollectionView,
//    layout _: UICollectionViewLayout,
//    sizeForItemAt indexPath: IndexPath)
//    -> CGSize
//  {
//    switch viewModel.state {
//    case .fake(let sections):
//      let type: FakeVinchyCollectionCellViewModel?
//      switch sections[safe: indexPath.section] {
//      case .stories(let viewModel):
//        type = viewModel
//
//      case .promo(let viewModel):
//        type = viewModel
//
//      case .title(let viewModel):
//        type = viewModel
//
//      case .big(let viewModel):
//        type = viewModel
//
//      case .none:
//        type = nil
//      }
//
//      let height = FakeVinchyCollectionCell.height(viewModel: type)
//      return .init(width: collectionView.frame.width, height: height)
//
//    case .normal(let sections):
//      switch sections[indexPath.section] {
//      case .title(let model):
//        let width = collectionView.frame.width - 2 * C.horizontalInset
//        let height = TextCollectionCell.height(viewModel: model[indexPath.row], width: width)
//        return .init(width: width, height: height)
//
//      case .stories(let model), .promo(let model), .big(let model), .bottles(let model):
//        return .init(
//          width: collectionView.frame.width,
//          height: SimpleContinuousCaruselCollectionCellView.height(viewModel: model[safe: indexPath.row]))
//
//      case .shareUs:
//        let width = collectionView.frame.width - 2 * C.horizontalInset
//        let height: CGFloat = 150 // TODO: -
//        return .init(width: width, height: height)
//
//      case .smartFilter:
//        let width = collectionView.frame.width - 2 * C.horizontalInset
//        let height: CGFloat = 170 // TODO: -
//        return .init(width: width, height: height)
//
//      case .storeTitle(let model):
//        let width = collectionView.frame.width - 2 * C.horizontalInset
//        let height: CGFloat = StoreTitleCollectionCell.height(viewModel: model[safe: indexPath.row], for: width)
//        return .init(width: width, height: height)
//      }
//    }
//  }
//
//  func collectionView(
//    _: UICollectionView,
//    layout _: UICollectionViewLayout,
//    insetForSectionAt section: Int)
//    -> UIEdgeInsets
//  {
//    switch viewModel.state {
//    case .fake(let sections):
//      switch sections[section] {
//      case .stories, .big, .promo:
//        return .zero
//
//      case .title:
//        return .init(top: 10, left: 0, bottom: 10, right: 0)
//      }
//
//    case .normal(let sections):
//      switch sections[section] {
//      case .title:
//        return .init(top: 16, left: C.horizontalInset, bottom: 8, right: C.horizontalInset)
//
//      case .shareUs, .smartFilter:
//        return .init(top: 15, left: C.horizontalInset, bottom: 10, right: C.horizontalInset)
//
//      case .stories:
//        return .init(top: 0, left: 0, bottom: 8, right: 0)
//
//      case .promo, .big, .bottles:
//        return .zero
//
//      case .storeTitle:
//        return .init(top: 16, left: 0, bottom: 8, right: 0)
//      }
//    }
//  }
//
//  func numberOfSections(in _: UICollectionView) -> Int {
//    switch viewModel.state {
//    case .fake(let sections):
//      return sections.count
//
//    case .normal(let sections):
//      return sections.count
//    }
//  }
//
//  func collectionView(
//    _: UICollectionView,
//    numberOfItemsInSection section: Int)
//    -> Int
//  {
//    switch viewModel.state {
//    case .fake(let sections):
//      switch sections[section] {
//      case .stories, .promo, .title, .big:
//        return 1
//      }
//
//    case .normal(sections: let sections):
//      switch sections[section] {
//      case .title(let model):
//        return model.count
//
//      case .stories(let model), .promo(let model), .big(let model), .bottles(let model):
//        return model.count
//
//      case .shareUs(let model):
//        return model.count
//
//      case .smartFilter(let model):
//        return model.count
//
//      case .storeTitle(let model):
//        return model.count
//      }
//    }
//  }
//
//  func collectionView(
//    _ collectionView: UICollectionView,
//    cellForItemAt indexPath: IndexPath)
//    -> UICollectionViewCell
//  {
//    switch viewModel.state {
//    case .fake(let sections):
//      switch sections[indexPath.section] {
//      case .stories(let model), .promo(let model), .title(let model), .big(let model):
//        // swiftlint:disable:next force_cast
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FakeVinchyCollectionCell.reuseId, for: indexPath) as! FakeVinchyCollectionCell
//        cell.decorate(model: model)
//        return cell
//      }
//
//    case .normal(let sections):
//      switch sections[indexPath.section] {
//      case .title(let model):
//        // swiftlint:disable:next force_cast
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCollectionCell.reuseId, for: indexPath) as! TextCollectionCell
//        cell.decorate(model: model[indexPath.row])
//        return cell
//
//      case .stories(let model), .promo(let model), .big(let model), .bottles(let model):
//        collectionView.register(
//          SimpleContinuousCaruselCollectionCellView.self,
//          forCellWithReuseIdentifier: SimpleContinuousCaruselCollectionCellView.reuseId + "\(indexPath.section)")
//
//        let cell = collectionView.dequeueReusableCell(
//          withReuseIdentifier: SimpleContinuousCaruselCollectionCellView.reuseId + "\(indexPath.section)",
//          for: indexPath) as! SimpleContinuousCaruselCollectionCellView // swiftlint:disable:this force_cast
//
//        let configurator = SimpleContinuosCarouselCollectionCellConfigurator(delegate: self)
//        configurator.configure(view: cell, with: SimpleContinuosCarouselCollectionCellInput(model: model[indexPath.row]))
//        cell.viewDidLoad()
//        return cell
//
//      case .shareUs(let model):
//        // swiftlint:disable:next force_cast
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShareUsCollectionCell.reuseId, for: indexPath) as! ShareUsCollectionCell
//        cell.decorate(model: model[indexPath.row])
//        cell.delegate = self
//        return cell
//
//      case .smartFilter(let model):
//        // swiftlint:disable:next force_cast
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SmartFilterCollectionCell.reuseId, for: indexPath) as! SmartFilterCollectionCell
//        cell.decorate(model: model[indexPath.row])
//        return cell
//
//      case .storeTitle(let model):
//        // swiftlint:disable:next force_cast
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreTitleCollectionCell.reuseId, for: indexPath) as! StoreTitleCollectionCell
//        cell.decorate(model: model[indexPath.row])
//        cell.delegate = self
//        return cell
//      }
//    }
//  }
//}

extension VinchyViewController: VinchyViewControllerProtocol {

  var scrollableToTopScrollView: UIScrollView {
    collectionView
  }

  func stopPullRefreshing() {
    refreshControl.endRefreshing()
  }

  func updateUI(viewModel: VinchyViewControllerViewModel) {
    collectionView.scrollToTopForcingSearchBar()
    self.viewModel = viewModel
  }
}

// MARK: ShareUsCollectionCellDelegate

extension VinchyViewController: ShareUsCollectionCellDelegate {
  func didTapShareUs(_ button: UIButton) {
    let items = [localized("i_use_vinchy"), localized("discovery_link")]
    let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
    if let popoverController = controller.popoverPresentationController {
      popoverController.sourceView = button
      popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
    }
    present(controller, animated: true)
  }
}

// MARK: BottlesCollectionViewDelegate

//extension VinchyViewController: SimpleContinuosCarouselCollectionCellInteractorDelegate {
//  func didTapCompilationCell(input: ShowcaseInput) {
//    interactor?.didTapCompilationCell(input: input)
//  }
//
//  func didTapBottleCell(wineID: Int64) {
//    interactor?.didTapBottleCell(wineID: wineID)
//  }
//}

extension VinchyViewController: BottlesCollectionViewDelegate {
  func didTapShareContextMenu(wineID: Int64, sourceView: UIView) {

  }

  func didTapWriteNoteContextMenu(wineID: Int64) {

  }

  func didTap(wineID: Int64) {
    interactor?.didTapBottleCell(wineID: wineID)
  }
}

// MARK: StoreTitleCollectionCellDelegate

extension VinchyViewController: StoreTitleCollectionCellDelegate {
  func didTapSeeAllStore(affilatedId: Int) {
    interactor?.didTapSeeStore(affilatedId: affilatedId)
  }
}

// @objc private func didTapCamera() {
//    if let window = view.window {
//        let transition = CATransition()
//        transition.duration = 0.35
//        transition.type = .push
//        transition.subtype = .fromLeft
//        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
//        window.layer.add(transition, forKey: kCATransition)
//
//        let vc = VNDocumentCameraViewController()
//        vc.delegate = self
//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: false, completion: nil)
//    }
// }
