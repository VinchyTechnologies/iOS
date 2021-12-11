//
//  SavedViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 03.11.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

// MARK: - BarScrollPercentageCoordinating

import Display
import EpoxyBars
import EpoxyCollectionView
import EpoxyCore
import UIKit

// MARK: - BarScrollPercentageCoordinating

//final class SSavedViewController: UIViewController {
//
//  // MARK: Internal
//
//  var interactor: SavedInteractorProtocol?
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//
////    edgesForExtendedLayout = []
//    navigationItem.largeTitleDisplayMode = .never
//
//    view.addSubview(collectionView)
//    collectionView.translatesAutoresizingMaskIntoConstraints = false
//    NSLayoutConstraint.activate([
//      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
//      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//    ])
//
//    interactor?.viewDidLoad()
//
////    topBarInstaller.install()
//    updateUI(
//      viewModel: .init(
//        sections: [.liked, .liked],
//        navigationTitleText: "Saved",
//        topTabBarViewModel: .init(
//          items: [
//            .init(titleText: "Liked"),
//            .init(titleText: "My rates"),
//          ],
//          initiallySelectedIndex: 0)))
//  }
//
//  override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
//    super.willTransition(to: newCollection, with: coordinator)
//    coordinator.animate { _ in
//      self.collectionView.setSections(self.sections, animated: false)
//    } completion: { _ in
//    }
//  }
//
//  override func viewWillLayoutSubviews() {
//    super.viewWillLayoutSubviews()
//    collectionView.collectionViewLayout.invalidateLayout()
//  }
//
//  override func viewDidLayoutSubviews() {
//    super.viewDidLayoutSubviews()
//    collectionView.setContentOffset(
//      .init(
//        x: CGFloat(currentPage) * view.frame.size.width,
//        y: collectionView.contentOffset.y),
//      animated: false)
//  }
//
//  // MARK: Private
//
//  private var currentPage = 0
//
//  private lazy var collectionView = makeCollectionView()
//
//  private let layout = UICollectionViewFlowLayout()
//
//  private lazy var topBarInstaller = TopBarInstaller(
//    viewController: self,
//    bars: bars)
//
//  private var viewModel: SavedViewModel = .empty
//
//  @SectionModelBuilder
//  private var sections: [SectionModel] {
//    viewModel.sections.map({ section in
//      switch section {
//      case .liked:
//        return SectionModel(dataID: UUID()) {
//          ControllerCell.itemModel(
//            dataID: UUID(),
//            content: .init(id: UUID().uuidString),
//            style: .init(id: UUID().uuidString))
//            .setBehaviors({ [unowned self] context in
//              addChild(context.view.vc)
//              context.view.vc.didMove(toParent: self)
//            })
//        }
//      }
//    })
//  }
//
//  @BarModelBuilder
//  private var bars: [BarModeling] {
//    [
//      TopTabBarView.barModel(
//        dataID: nil,
//        content: viewModel.topTabBarViewModel,
//        behaviors: .init(didSelect: { [weak self] index in
//          let x = (self?.view.frame.width ?? 0) * CGFloat(index)
//          let y = self?.collectionView.contentOffset.y ?? 0
//          self?.collectionView.setContentOffset(.init(x: x, y: y), animated: true)
//        }),
//        style: .init())
//        .makeCoordinator(ScrollPercentageBarCoordinator.init),
//    ]
//  }
//
//  private func makeCollectionView() -> CollectionView {
//    layout.scrollDirection = .horizontal
//    layout.minimumLineSpacing = 0
//    layout.minimumInteritemSpacing = 0
//    let collectionView = CollectionView(
//      layout: layout,
//      configuration: .init(
//        usesBatchUpdatesForAllReloads: false,
//        usesCellPrefetching: true,
//        usesAccurateScrollToItem: true))
//
//    collectionView.layoutDelegate = self
//    collectionView.isPagingEnabled = true
//    collectionView.scrollDelegate = self
////    collectionView.directionalLayoutMargins = .zero
//    collectionView.showsHorizontalScrollIndicator = false
////    collectionView.contentInsetAdjustmentBehavior = .always
//    collectionView.alwaysBounceVertical = false
//    collectionView.alwaysBounceHorizontal = false
//    let topSafeAreaHeight = (UIApplication.shared.asKeyWindow?.safeAreaInsets.top ?? 0)
//    let bottomSafeAreaHeight = (UIApplication.shared.asKeyWindow?.safeAreaInsets.bottom ?? 0)
//    let statusBar = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
////    let tabbarHeight = tabBarController?.tabBar.frame.height ?? 0
//    collectionView.contentInset = .init(
//      top: statusBar + topSafeAreaHeight + (navigationController?.navigationBar.frame.height ?? 0), left: 0, bottom: bottomSafeAreaHeight, right: 0)
//    return collectionView
//  }
//}
//
//// MARK: - SavedViewController + SavedViewControllerProtocol
//
//extension SavedViewController: SavedViewControllerProtocol {
//  func updateUI(viewModel: SavedViewModel) {
//    self.viewModel = viewModel
//    navigationItem.title = viewModel.navigationTitleText
////    topBarInstaller.setBars(bars, animated: true)
//    collectionView.setSections(sections, animated: true)
//  }
//}
//
//extension SavedViewController: UIScrollViewDelegate {
//  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//    let index = Int(scrollView.contentOffset.x / view.frame.width)
//    currentPage = index
//    topBarInstaller.scrollPercentage = CGFloat(index)
//  }
//}

public protocol BarScrollPercentageCoordinating: AnyObject {
  var scrollPercentage: CGFloat { get set }
}

extension BarCoordinatorProperty {
  fileprivate static var scrollPercentage: BarCoordinatorProperty<CGFloat> {
    .init(keyPath: \BarScrollPercentageCoordinating.scrollPercentage, default: 0)
  }
}

// MARK: - TopBarInstaller + BarScrollPercentageCoordinating

extension TopBarInstaller: BarScrollPercentageCoordinating {
  public var scrollPercentage: CGFloat {
    get { self[.scrollPercentage] }
    set { self[.scrollPercentage] = newValue }
  }
}

// MARK: - ScrollPercentageBarCoordinator

final class ScrollPercentageBarCoordinator: BarCoordinating, BarScrollPercentageCoordinating {

  // MARK: Lifecycle

  public init(updateBarModel: @escaping (_ animated: Bool) -> Void) {}

  // MARK: Public

  public var scrollPercentage: CGFloat = 0 {
    didSet {
      updateScrollPercentage()
    }
  }

  public func barModel(for model: BarModel<TopTabBarView>) -> BarModeling {
    model.willDisplay { [weak self] view in
      self?.view = view.view
    }
  }

  // MARK: Private

  private weak var view: TopTabBarView? {
    didSet {
      updateScrollPercentage()
    }
  }

  private func updateScrollPercentage() {
    view?.scrollPercentage = scrollPercentage
  }
}

// MARK: - SavedViewController + EpoxyCollectionViewDelegateFlowLayout

//extension SavedViewController: EpoxyCollectionViewDelegateFlowLayout {
//  func collectionView(
//    _ collectionView: UICollectionView,
//    layout collectionViewLayout: UICollectionViewLayout,
//    sizeForItemWith dataID: AnyHashable,
//    inSectionWith sectionDataID: AnyHashable)
//    -> CGSize
//  {
//    view.frame.size
//  }
//
//  func collectionView(
//    _ collectionView: UICollectionView,
//    layout collectionViewLayout: UICollectionViewLayout,
//    insetForSectionWith sectionDataID: AnyHashable)
//    -> UIEdgeInsets
//  {
//    .zero
//  }
//}
