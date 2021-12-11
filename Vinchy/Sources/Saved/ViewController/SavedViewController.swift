//
//  SavedViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 05.11.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import EpoxyBars
import EpoxyCollectionView
import EpoxyCore
import StringFormatting
import ThirdParty
import UIKit

// MARK: - SavedViewController

final class SavedViewController: UIViewController, SavedViewControllerProtocol, ScrollableToTop {

  // MARK: Internal

  var interactor: SavedInteractorProtocol?

  var viewControllers: [UIViewController] = [
    LoveViewController(),
    RatesAssembly.assemblyModule(input: .init()),
  ]

  var scrollableToTopScrollView: UIScrollView {
    if let loveVC = viewControllers[safe: currentIndex] as? LoveViewController {
      return loveVC.collectionView
    } else if let ratesVC = viewControllers[safe: currentIndex] as? RatesViewController {
      return ratesVC.tableView
    } else {
      return UIScrollView()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .mainBackground
    navigationItem.largeTitleDisplayMode = .never

    pagingViewController.collectionView.delaysContentTouches = false
    pagingViewController.collectionView.backgroundColor = .mainBackground
    addChild(pagingViewController)
    view.addSubview(pagingViewController.view)
    pagingViewController.didMove(toParent: self)
    pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      pagingViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      pagingViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      pagingViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      pagingViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
    ])

    topBarInstaller.install()

    updateUI(viewModel: .init(
      sections: [.liked, .rates],
      navigationTitleText: localized("favourites").firstLetterUppercased(),
      topTabBarViewModel: .init(
        items: [.init(titleText: localized("♥︎").firstLetterUppercased()), .init(titleText: localized("rated").firstLetterUppercased())],
        initiallySelectedIndex: 0)))

  }

  // MARK: Private

  private var currentIndex = 0

  private lazy var pagingViewController: PagingViewController = {
    $0.delegate = self
    $0.dataSource = self
    return $0
  }(PagingViewController())

  private var viewModel: SavedViewModel = .empty

  private lazy var topBarInstaller = TopBarInstaller(
    viewController: self,
    bars: bars)

  @BarModelBuilder
  private var bars: [BarModeling] {
    [
      TopTabBarView.barModel(
        dataID: nil,
        content: viewModel.topTabBarViewModel,
        behaviors: .init(didSelect: { [weak self] index in
          self?.currentIndex = index
          self?.pagingViewController.select(index: index, animated: true)
        }),
        style: .init())
        .makeCoordinator(ScrollPercentageBarCoordinator.init),
    ]
  }
}

// MARK: PagingViewControllerDataSource

extension SavedViewController: PagingViewControllerDataSource {

  func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
    PagingIndexItem(index: index, title: "")
  }

  func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
    viewControllers[safe: index] ?? UIViewController()
  }

  func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
    viewControllers.count
  }
}

// MARK: PagingViewControllerDelegate

extension SavedViewController: PagingViewControllerDelegate {
  func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {
    guard
      let index = viewControllers.firstIndex(
        where: { $0 === destinationViewController })
    else {
      return
    }

    if transitionSuccessful {
      currentIndex = index
      topBarInstaller.scrollPercentage = CGFloat(index)
    }
  }
}

extension SavedViewController {
  func updateUI(viewModel: SavedViewModel) {
    self.viewModel = viewModel
    navigationItem.title = viewModel.navigationTitleText

//    viewControllers = viewModel.sections.compactMap { section in
//      switch section {
//      case .liked:
//        return DocumentsAssembly.assemblyModule()
//
//      case .rates:
//        return WineDetailAssembly.assemblyModule(input: .init(wineID: 891))
//      }
//    }
    // TODO: - Doesn't work

    topBarInstaller.setBars(bars, animated: true)
//    pagingViewController.reloadData()
  }
}
