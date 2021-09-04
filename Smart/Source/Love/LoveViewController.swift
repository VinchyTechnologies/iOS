//
//  LoveViewController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 10.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Database
import Display
import StringFormatting
import UIKit

// MARK: - LoveViewControllerState

private enum LoveViewControllerState: Int {
  case like = 0, dislike
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

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.largeTitleDisplayMode = .never
    currentState = .like
    navigationItem.titleView = segmentedControl

    view.addSubview(collectionView)
    collectionView.fill()
    collectionView.backgroundColor = .mainBackground
    collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    collectionView.delaysContentTouches = false
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
    let rowCount: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 3 : 2
    let inset: CGFloat = 10
    let itemWidth = Int((UIScreen.main.bounds.width - inset * (rowCount + 1)) / rowCount)
    let itemHeight = Int(Double(itemWidth) * 1.4)

    let layout = UICollectionViewFlowLayout()
    let sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    layout.sectionInset = sectionInset
    layout.minimumLineSpacing = inset
    layout.minimumInteritemSpacing = 0
    layout.itemSize = CGSize(width: itemWidth, height: itemHeight)

    return layout
  }()

  private let dataBase = winesRepository

  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
  private lazy var segmentedControl: UISegmentedControl = {
    let segmentedControl = UISegmentedControl(items: [
      localized("you_liked").firstLetterUppercased(),
      localized("you_disliked").firstLetterUppercased(),
    ])
    segmentedControl.selectedSegmentIndex = currentState.rawValue
    segmentedControl.backgroundColor = .option
    segmentedControl.selectedSegmentTintColor = .accent
    segmentedControl.setTitleTextAttributes([
      NSAttributedString.Key.foregroundColor: UIColor.white,
      NSAttributedString.Key.font: Font.bold(14),
    ], for: .selected)
    segmentedControl.setTitleTextAttributes([
      NSAttributedString.Key.foregroundColor: UIColor.blueGray,
      NSAttributedString.Key.font: Font.bold(14),
    ], for: .normal)
    segmentedControl.frame.size.height = 35
    segmentedControl.frame.size.width = widthSegmentedControl()
    segmentedControl.addTarget(
      self,
      action: #selector(didChangeIndexSegmantedControl(_:)),
      for: .valueChanged)
    return segmentedControl
  }()

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

  @objc
  private func didChangeIndexSegmantedControl(
    _ segmentedControl: UISegmentedControl)
  {
    currentState = LoveViewControllerState(
      rawValue: segmentedControl.selectedSegmentIndex) ?? .like
    HapticEffectHelper.vibrate(withEffect: .selection)
  }

  private func widthSegmentedControl() -> CGFloat {
    let maxWorldWidth = max(
      localized("you_liked").firstLetterUppercased().width(usingFont: Font.medium(16)),
      localized("you_liked").firstLetterUppercased().width(usingFont: Font.medium(16)))

    let maxWidth: CGFloat = view.frame.width - 40
    let actualWidth: CGFloat = (maxWorldWidth + 20) * CGFloat(2)

    return max(min(maxWidth, actualWidth), 200)
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
          subtitleText: nil, contextMenuViewModels: []))
    }

    return cell
  }
}

// MARK: UICollectionViewDelegate

extension LoveViewController: UICollectionViewDelegate {
  func collectionView(
    _: UICollectionView,
    didSelectItemAt indexPath: IndexPath)
  {
    guard let wineID = wines[safe: indexPath.row]?.wineID else { return }
    navigationController?.pushViewController(Assembly.buildDetailModule(wineID: wineID), animated: true)
  }
}

// MARK: ErrorViewDelegate

extension LoveViewController: ErrorViewDelegate {
  func didTapErrorButton(_: UIButton) {
    tabBarController?.selectedIndex = 0
  }
}
