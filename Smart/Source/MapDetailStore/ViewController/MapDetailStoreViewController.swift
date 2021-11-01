//
//  MapDetailStoreViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 06.05.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import CoreLocation
import Display
import FittedSheets
import UIKit
import VinchyCore

// MARK: - MapDetailStoreViewControllerDelegate

protocol MapDetailStoreViewControllerDelegate: AnyObject {
  func deselectSelectedPin()
  func didTapRouteButton(coordinate: CLLocationCoordinate2D)
  func didTapAssortmentButton(_ button: UIButton)
}

// MARK: - MapDetailStoreViewController

final class MapDetailStoreViewController: UIViewController {

  // MARK: Internal

  weak var delegate: MapDetailStoreViewControllerDelegate?
  var interactor: MapDetailStoreInteractorProtocol?

  private(set) var loadingIndicator = ActivityIndicatorView()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .mainBackground
    view.addSubview(collectionView)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
    sheetViewController?.handleScrollView(collectionView)

    interactor?.viewDidLoad()
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: { _ in
      self.collectionView.collectionViewLayout.invalidateLayout()
    })
  }

  // MARK: Private

  private lazy var layout: UICollectionViewFlowLayout = {
    $0.scrollDirection = .vertical
    $0.sectionHeadersPinToVisibleBounds = true
    return $0
  }(UICollectionViewFlowLayout())

  private lazy var collectionView: UICollectionView = {
    $0.backgroundColor = .mainBackground
    $0.dataSource = self
    $0.delegate = self
    $0.clipsToBounds = true
    $0.delaysContentTouches = false
    $0.contentInset = .init(top: 0 /* pull Bar height */, left: 0, bottom: 10, right: 0)
    $0.register(
      TextCollectionCell.self,
      WorkingHoursCollectionCell.self,
      AssortmentCollectionCell.self,
      SimpleContinuousCaruselCollectionCellView.self)
    $0.register(
      MapNavigationBarCollectionCell.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: MapNavigationBarCollectionCell.reuseId)
    return $0
  }(UICollectionView(frame: .zero, collectionViewLayout: layout))

  private var viewModel: MapDetailStoreViewModel? {
    didSet {
      collectionView.reloadData()
      collectionView.performBatchUpdates({
        let safeAreaBottomInset: CGFloat = UIApplication.shared.asKeyWindow?.safeAreaInsets.bottom ?? 0
        let sheetHeight: CGFloat =
          self.layout.collectionViewContentSize.height + .pullBarHeight + .bottomInset + safeAreaBottomInset
        let sheetSize = SheetSize.fixed(sheetHeight)
        self.sheetViewController?.sizes = [sheetSize]
        self.sheetViewController?.resize(to: [sheetSize][0], duration: 0.5)
      }, completion: nil) // This blocks layoutIfNeeded animation
    }
  }
}

// MARK: UICollectionViewDataSource

extension MapDetailStoreViewController: UICollectionViewDataSource {
  func numberOfSections(in _: UICollectionView) -> Int {
    viewModel?.sections.count ?? 0
  }

  func collectionView(
    _: UICollectionView,
    numberOfItemsInSection section: Int)
    -> Int
  {
    switch viewModel?.sections[safe: section] {
    case .content(_, let items):
      return items.count

    case .none:
      return 0
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell
  {
    switch viewModel?.sections[safe: indexPath.section] {
    case .content(_, let items):
      switch items[indexPath.row] {
      case .title(let model), .address(let model):
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCollectionCell.reuseId, for: indexPath) as! TextCollectionCell
        cell.decorate(model: model)
        return cell

      case .workingHours(let model):
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkingHoursCollectionCell.reuseId, for: indexPath) as! WorkingHoursCollectionCell
        cell.decorate(model: model)
        return cell

      case .assortment(let model):
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AssortmentCollectionCell.reuseId, for: indexPath) as! AssortmentCollectionCell
        cell.decorate(model: model)
        cell.delegate = self
        return cell

      case .recommendedWines(let model):
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: SimpleContinuousCaruselCollectionCellView.reuseId,
          for: indexPath) as! SimpleContinuousCaruselCollectionCellView // swiftlint:disable:this force_cast
        let configurator = SimpleContinuosCarouselCollectionCellConfigurator(delegate: self)
        configurator.configure(view: cell, with: SimpleContinuosCarouselCollectionCellInput(model: model))
        cell.viewDidLoad()
        return cell
      }

    case .none:
      return .init()
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath)
    -> UICollectionReusableView
  {
    if kind == UICollectionView.elementKindSectionHeader {
      switch viewModel?.sections[safe: indexPath.section] {
      case .content(let model, _):
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MapNavigationBarCollectionCell.reuseId, for: indexPath) as! MapNavigationBarCollectionCell // swiftlint:disable:this force_cast
        cell.decorate(model: model)
        cell.delegate = self
        return cell

      case .none:
        return .init()
      }
    } else {
      return .init()
    }
  }
}

// MARK: UICollectionViewDelegateFlowLayout

extension MapDetailStoreViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout _: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int)
    -> CGSize
  {
    switch viewModel?.sections[safe: section] {
    case .content:
      return .init(width: collectionView.frame.width, height: 48)

    case .none:
      return .zero
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout _: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath)
    -> CGSize
  {
    let width = collectionView.frame.width - 15 * 2
    switch viewModel?.sections[safe: indexPath.section] {
    case .content(_, let items):
      switch items[safe: indexPath.row] {
      case .title(let model), .address(let model):
        return .init(width: width, height: TextCollectionCell.height(viewModel: model, width: width))

      case .assortment:
        return .init(width: width, height: 48)

      case .workingHours:
        return .init(width: width, height: 48)

      case .recommendedWines:
        return .init(width: collectionView.frame.width, height: 250)

      case .none:
        return .zero
      }
    case .none:
      return .zero
    }
  }
}

// MARK: MapDetailStoreViewControllerProtocol

extension MapDetailStoreViewController: MapDetailStoreViewControllerProtocol {
  func updateUI(viewModel: MapDetailStoreViewModel) {
    self.viewModel = viewModel
  }
}

// MARK: MapNavigationBarDelegate

extension MapDetailStoreViewController: MapNavigationBarDelegate {
  func didTapLeadingButton(_ button: UIButton) {
//    sheetViewController?.attemptDismiss(animated: true)

    interactor?.didTapRouteButton(button)
  }

  func didTapTrailingButton(_: UIButton) {
    sheetViewController?.attemptDismiss(animated: true)
  }
}

// MARK: AssortmentCollectionCellDelegate

extension MapDetailStoreViewController: AssortmentCollectionCellDelegate {
  func didTapSeeAssortmentButton(_ button: UIButton) {
    delegate?.didTapAssortmentButton(button)
  }
}

// MARK: SimpleContinuosCarouselCollectionCellInteractorDelegate

extension MapDetailStoreViewController: SimpleContinuosCarouselCollectionCellInteractorDelegate {
  func didTapCompilationCell(input: ShowcaseInput) { }

  func didTapBottleCell(wineID: Int64) {
    interactor?.didTapRecommendedWine(wineID: wineID)
  }
}

extension CGFloat {
  fileprivate static let pullBarHeight: Self = 24
  fileprivate static let bottomInset: Self = 10
}
