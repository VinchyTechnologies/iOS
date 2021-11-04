//
//  SavedViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 03.11.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import Epoxy
import UIKit

// MARK: - SavedViewController

final class SavedViewController: CollectionViewController {

  // MARK: Lifecycle

  init() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    super.init(layout: layout)
  }

  // MARK: Internal

  var interactor: SavedInteractorProtocol?

  var height: CGFloat {
    let navBarHeight = (navigationController?.navigationBar.frame.height ?? 0)
    let tabBarHeight = (tabBarController?.tabBar.frame.height ?? 0)
    let topSafeAreaHeight = (UIApplication.shared.asKeyWindow?.safeAreaInsets.top ?? 0)
    let topBarHeight: CGFloat = 56
    return view.frame.height - navBarHeight - tabBarHeight - topBarHeight - topSafeAreaHeight
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    edgesForExtendedLayout = []
    navigationItem.largeTitleDisplayMode = .never

    interactor?.viewDidLoad()

    topBarInstaller.install()
    updateUI(
      viewModel: .init(
        sections: [.liked, .liked],
        navigationTitleText: "Saved",
        topTabBarViewModel: .init(
          items: [
            .init(titleText: "Liked"),
            .init(titleText: "My rates"),
          ],
          initiallySelectedIndex: 0)))
  }

  override func makeCollectionView() -> CollectionView {
    let collectionView = CollectionView(layout: layout)
    collectionView.isPagingEnabled = true
    collectionView.scrollDelegate = self
    collectionView.directionalLayoutMargins = .zero
    collectionView.showsHorizontalScrollIndicator = false
    return collectionView
  }

  // MARK: Private

  private lazy var topBarInstaller = TopBarInstaller(
    viewController: self,
    bars: bars)

  private var viewModel: SavedViewModel = .empty

  @SectionModelBuilder
  private var sections: [SectionModel] {
    viewModel.sections.map({ section in
      switch section {
      case .liked:
        return SectionModel(dataID: UUID()) {
          ControllerCell.itemModel(
            dataID: UUID(),
            content: .init(id: UUID().uuidString),
            style: .init(id: UUID().uuidString))
            .setBehaviors({ [unowned self] context in
              addChild(context.view.vc)
              context.view.vc.didMove(toParent: self)
            })
        }
        .flowLayoutSectionInset(.zero)
        .flowLayoutItemSize(.init(width: view.frame.width, height: self.height))
      }
    })
  }

  @BarModelBuilder
  private var bars: [BarModeling] {
    [
      TopTabBarView.barModel(
        dataID: nil,
        content: viewModel.topTabBarViewModel,
        behaviors: .init(didSelect: { [weak self] index in
          let x = (self?.view.frame.width ?? 0) * CGFloat(index)
          let y = self?.collectionView.contentOffset.y ?? 0
          self?.collectionView.setContentOffset(.init(x: x, y: y), animated: true)
        }),
        style: .init())
        .makeCoordinator(ScrollPercentageBarCoordinator.init),
    ]
  }

}

// MARK: SavedViewControllerProtocol

extension SavedViewController: SavedViewControllerProtocol {
  func updateUI(viewModel: SavedViewModel) {
    self.viewModel = viewModel
    navigationItem.title = viewModel.navigationTitleText
    setSections(sections, animated: true)
    topBarInstaller.setBars(bars, animated: true)
  }
}

// MARK: UIScrollViewDelegate

extension SavedViewController: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let index = Int(scrollView.contentOffset.x / view.frame.width)
    topBarInstaller.scrollPercentage = CGFloat(index)
  }
}

// MARK: - BarScrollPercentageCoordinating

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
