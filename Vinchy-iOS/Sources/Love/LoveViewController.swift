//
//  LoveViewController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 10.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Database
import DisplayMini
import StringFormatting
import UIKit
import WineDetail

// MARK: - LoveViewControllerState

private enum LoveViewControllerState: Int {
  case like = 0, dislike
}

// MARK: - C

fileprivate enum C {
  static let inset: CGFloat = 10
}

// MARK: - LoveViewController

final class LoveViewController: UIViewController {

  // MARK: Lifecycle

  init() {
    super.init(nibName: nil, bundle: nil)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(WineCollectionViewCell.self, forCellWithReuseIdentifier: WineCollectionViewCell.reuseId)
    collectionView.delaysContentTouches = false
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Internal

  let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)

  override func viewDidLoad() {
    super.viewDidLoad()

//    navigationItem.largeTitleDisplayMode = .never
    currentState = .like
//    navigationItem.titleView = segmentedControl

    view.addSubview(collectionView)
    collectionView.fill()
    collectionView.backgroundColor = .mainBackground
    collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    collectionView.delaysContentTouches = false
    collectionView.alwaysBounceVertical = true
    collectionView.alwaysBounceHorizontal = false
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let current = currentState
    currentState = current
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: { _ in
      self.collectionView.collectionViewLayout.invalidateLayout()
    })
  }

  // MARK: Private

  private static let collectionViewLayout: UICollectionViewLayout = {
    let layout = UICollectionViewFlowLayout()
    let sectionInset = UIEdgeInsets(top: 0, left: C.inset, bottom: 0, right: C.inset)
    layout.sectionInset = sectionInset
    layout.minimumLineSpacing = C.inset
    layout.minimumInteritemSpacing = 0

    return layout
  }()

  private let dataBase = winesRepository

  private var currentState: LoveViewControllerState = .like {
    didSet {
      if currentState == .like {
        wines = dataBase.findAll().filter { $0.isLiked == true }
      } else if currentState == .dislike {
        wines = dataBase.findAll().filter { $0.isDisliked == true }
      }
    }
  }

  private var wines: [VWine] = [] {
    didSet {
      wines.isEmpty ? showEmptyView() : hideEmptyView()
      collectionView.reloadData()
    }
  }

  private func hideEmptyView() {
    collectionView.backgroundView = nil
  }

  private func showEmptyView() {
    let errorView = ErrorView(frame: view.frame)
    errorView.decorate(
      model: .init(
        titleText: localized("nothing_here").firstLetterUppercased(),
        subtitleText: nil,
        buttonText: localized("add").firstLetterUppercased()))
    errorView.delegate = self
    collectionView.backgroundView = errorView
  }
}

// MARK: UICollectionViewDataSource

extension LoveViewController: UICollectionViewDataSource {
  func collectionView(
    _: UICollectionView,
    numberOfItemsInSection _: Int)
    -> Int
  {
    wines.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell
  {
    guard let wine = wines[safe: indexPath.row] else { return .init() }
    // swiftlint:disable:next force_cast
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WineCollectionViewCell.reuseId, for: indexPath) as! WineCollectionViewCell

    if let wineID = wine.wineID, let title = wine.title {
      cell.decorate(
        model: .init(
          wineID: wineID,
          imageURL: imageURL(from: wineID).toURL,
          titleText: title,
          subtitleText: nil,
          rating: nil,
          contextMenuViewModels: []))
    }

    return cell
  }
}

// MARK: UICollectionViewDelegateFlowLayout

extension LoveViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _: UICollectionView,
    didSelectItemAt indexPath: IndexPath)
  {
    guard let wineID = wines[safe: indexPath.row]?.wineID else { return }
    let controller = WineDetailAssembly.assemblyModule(input: .init(wineID: wineID, mode: .normal, isAppClip: false, shouldShowSimilarWine: true), coordinator: Coordinator.shared, adGenerator: AdFabric.shared)
    controller.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(controller, animated: true)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath)
    -> CGSize
  {
    let rowCount: Int = {
      if UIDevice.current.userInterfaceIdiom == .pad {
        if Orientation.isLandscape {
          return 4
        } else {
          return 3
        }
      } else {
        return 2
      }
    }()

    let itemWidth = Int((UIScreen.main.bounds.width - C.inset * CGFloat(rowCount + 1)) / CGFloat(rowCount))
    let itemHeight = Int(Double(itemWidth) * 1.5)
    return CGSize(width: itemWidth, height: itemHeight)
  }
}

// MARK: ErrorViewDelegate

extension LoveViewController: ErrorViewDelegate {
  func didTapErrorButton(_: UIButton) {
    tabBarController?.selectedIndex = 0
  }
}

// MARK: ScrollableToTop

extension LoveViewController: ScrollableToTop {
  var scrollableToTopScrollView: UIScrollView {
    collectionView
  }
}
