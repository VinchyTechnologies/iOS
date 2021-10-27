//
//  VinchyViewController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.08.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Display
import Epoxy
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
    super.init(layout: UICollectionViewFlowLayout())
  }

  // MARK: Internal

  var interactor: VinchyInteractorProtocol?

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .mainBackground
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

    interactor?.viewDidLoad()
  }

  override func makeCollectionView() -> CollectionView {
    let collectionView = super.makeCollectionView()
    collectionView.backgroundColor = .mainBackground
    collectionView.delaysContentTouches = false
    collectionView.keyboardDismissMode = .onDrag
//    collectionView.refreshControl = refreshControl
    collectionView.pullToRefreshEnabled = true

    return collectionView
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: { _ in
      self.setSections(self.sections, animated: false)
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

  @SectionModelBuilder
  private var sections: [SectionModel] {
    switch viewModel.state {
    case .fake(let sections):
      sections.compactMap { section in
        switch section {
        case .stories(let content), .title(let content), .promo(let content), .big(let content):
          let width: CGFloat = view.frame.width
          let height: CGFloat = FakeVinchyCollectionCell.height(viewModel: content)
          return SectionModel(dataID: UUID()) {
            FakeVinchyCollectionCell.itemModel(
              dataID: UUID(),
              content: content,
              style: .init())
          }
          .flowLayoutItemSize(.init(width: width, height: height))
          .flowLayoutSectionInset(.init(top: 0, left: 0, bottom: 8, right: 0))
        }
      }

    case .normal(let sections):
      sections.compactMap { section in
        switch section {
        case .bottles(let content):
          let width: CGFloat = view.frame.width
          let height: CGFloat = 250
          return SectionModel(dataID: UUID()) {
            BottlesCollectionView.itemModel(
              dataID: UUID(),
              content: content,
              style: .init(offset: .small))
              .setBehaviors({ [weak self] context in
                context.view.bottlesCollectionViewDelegate = self
              })
          }
          .flowLayoutItemSize(.init(width: width, height: height))
          .flowLayoutSectionInset(.init(top: 0, left: 0, bottom: 8, right: 0))

        case .title(let content):
          let style: Label.Style = .style(with: TextStyle.lagerTitle)
          let width: CGFloat = view.frame.width - 2 * C.horizontalInset
          let height: CGFloat = Label.height(for: content, width: width, style: style)
          return SectionModel(dataID: UUID()) {
            Label.itemModel(
              dataID: UUID(),
              content: content,
              style: style)
          }
          .flowLayoutItemSize(.init(width: width, height: height))
          .flowLayoutSectionInset(.init(top: 16, left: C.horizontalInset, bottom: 8, right: C.horizontalInset))

        case .stories(let content):
          let width: CGFloat = view.frame.width
          let height: CGFloat = 135
          return SectionModel(dataID: UUID()) {
            StoriesCollectionView.itemModel(
              dataID: UUID(),
              content: content,
              style: .init())
              .setBehaviors { [weak self] context in
                context.view.storiesCollectionViewDelegate = self
              }
              .flowLayoutItemSize(.init(width: width, height: height))
          }
          .flowLayoutSectionInset(.init(top: 0, left: 0, bottom: 8, right: 0))

        case .storeTitle(let content):
          let width: CGFloat = view.frame.width - 2 * C.horizontalInset
          let height: CGFloat = content.height(for: width)
          return SectionModel(dataID: UUID()) {
            StoreTitleView.itemModel(
              dataID: UUID(),
              content: content,
              style: .init())
              .setBehaviors { [weak self] context in
                context.view.delegate = self
              }
              .flowLayoutItemSize(.init(width: width, height: height))
          }
          .flowLayoutSectionInset(.init(top: 8, left: C.horizontalInset, bottom: 16, right: C.horizontalInset))

        case .commonSubtitle(let content, let style):
          let width: CGFloat = view.frame.width
          let height: CGFloat = BigCollectionView.height(for: style)
          return SectionModel(dataID: UUID()) {
            BigCollectionView.itemModel(
              dataID: UUID(),
              content: content,
              style: style)
              .setBehaviors { [weak self] context in
                context.view.storiesCollectionViewDelegate = self
              }
              .flowLayoutItemSize(.init(width: width, height: height))
          }
          .flowLayoutSectionInset(.init(top: 0, left: 0, bottom: 8, right: 0))

        case .shareUs(let content):
          let width: CGFloat = view.frame.width - 2 * C.horizontalInset
          let height: CGFloat = 160
          return SectionModel(dataID: UUID()) {
            ShareUsView.itemModel(
              dataID: UUID(),
              content: content,
              style: .init())
              .setBehaviors { [weak self] context in
                context.view.delegate = self
              }
              .flowLayoutItemSize(.init(width: width, height: height))
          }
          .flowLayoutSectionInset(.init(top: 16, left: C.horizontalInset, bottom: 8, right: C.horizontalInset))

        case .nearestStoreTitle(let content):
          let style: Label.Style = .init(
            font: Font.bold(22),
            showLabelBackground: true,
            backgroundColor: .mainBackground,
            textColor: .dark)
          let width: CGFloat = view.frame.width - 2 * C.horizontalInset
          let height: CGFloat = Label.height(for: content, width: width, style: style)
          return SectionModel(dataID: UUID()) {
            Label.itemModel(
              dataID: UUID(),
              content: content,
              style: style)
              .flowLayoutItemSize(.init(width: width, height: height))
          }
          .flowLayoutSectionInset(.init(top: 16, left: C.horizontalInset, bottom: 16, right: C.horizontalInset))

        case .harmfullToYourHealthTitle(let content):
          let style: Label.Style = .init(
            font: Font.light(15),
            showLabelBackground: true,
            backgroundColor: .mainBackground,
            textAligment: .justified,
            textColor: .blueGray)
          let width: CGFloat = view.frame.width - 2 * C.horizontalInset
          let height: CGFloat = Label.height(for: content, width: width, style: style)
          return SectionModel(dataID: UUID()) {
            Label.itemModel(
              dataID: UUID(),
              content: content,
              style: style)
              .flowLayoutItemSize(.init(width: width, height: height))
          }
          .flowLayoutSectionInset(.init(top: 8, left: C.horizontalInset, bottom: 8, right: C.horizontalInset))
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

// MARK: StoriesCollectionViewDelegate

extension VinchyViewController: StoriesCollectionViewDelegate {
  func didTapStory(title: String?, shortWines: [ShortWine]) {
    interactor?.didTapCompilationCell(input: .init(title: title, mode: .normal(wines: shortWines)))
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
