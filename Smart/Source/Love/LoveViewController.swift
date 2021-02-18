//
//  LoveViewController.swift
//  Smart
//
//  Created by Aleksei Smirnov on 10.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import RealmSwift
import CommonUI
import StringFormatting
import Database
import Display

private enum LoveViewControllerState: Int {
  case like = 0, dislike
}

final class LoveViewController: UIViewController {
  
  private let dataBase = Database<DBWine>()
  
  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
  
  private static let collectionViewLayout: UICollectionViewLayout = {
    let rowCount = UIDevice.current.userInterfaceIdiom == .pad ? 3 : 2
    let inset: CGFloat = 10
    let itemWidth = Int((UIScreen.main.bounds.width - inset * CGFloat(rowCount + 1)) / CGFloat(rowCount))
    let itemHeight = Int(Double(itemWidth) * 1.4)
    
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    layout.minimumLineSpacing = inset
    layout.minimumInteritemSpacing = 0
    layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
    
    return layout
  }()
  
  private var currentState: LoveViewControllerState = .like {
    didSet {
      if currentState == .like {
        wines = dataBase.all(at: .like)
      } else if currentState == .dislike {
        wines = dataBase.all(at: .dislike)
      }
    }
  }

  private lazy var segmentedControl: UISegmentedControl = {
    let segmentedControl = UISegmentedControl(items: [
      localized("you_liked").firstLetterUppercased(),
      localized("you_disliked").firstLetterUppercased()
    ])
    segmentedControl.selectedSegmentIndex = currentState.rawValue
    segmentedControl.backgroundColor = .option
    segmentedControl.selectedSegmentTintColor = .accent
    segmentedControl.setTitleTextAttributes([
      NSAttributedString.Key.foregroundColor: UIColor.white,
      NSAttributedString.Key.font: Font.bold(14)
    ], for: .selected)
    segmentedControl.setTitleTextAttributes([
      NSAttributedString.Key.foregroundColor: UIColor.blueGray,
      NSAttributedString.Key.font: Font.bold(14)
    ], for: .normal)
    segmentedControl.frame.size.height = 35
    segmentedControl.frame.size.width = widthSegmentedControl()
    segmentedControl.addTarget(
      self,
      action: #selector(didChangeIndexSegmantedControl(_:)),
      for: .valueChanged)
    return segmentedControl
  }()
  
  private lazy var likeRealm = realm(path: .like)
  private var likeNotificationToken: NotificationToken?
  
  private lazy var dislikeRealm = realm(path: .dislike)
  private var dislikeNotificationToken: NotificationToken?
  
  private var wines: [DBWine] = [] {
    didSet {
      wines.isEmpty ? showEmptyView() : hideEmptyView()
      collectionView.reloadData()
    }
  }
  
  init() {
    super.init(nibName: nil, bundle: nil)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(WineCollectionViewCell.self, forCellWithReuseIdentifier: WineCollectionViewCell.reuseId)
    collectionView.delaysContentTouches = false
    
    likeNotificationToken = likeRealm.observe { _, _ in
      if self.currentState == .like {
        self.wines = self.dataBase.all(at: .like)
      }
    }
    
    dislikeNotificationToken = dislikeRealm.observe { _, _ in
      if self.currentState == .dislike {
        self.wines = self.dataBase.all(at: .dislike)
      }
    }
  }
  
  required init?(coder: NSCoder) { fatalError() }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    currentState = .like
    navigationItem.titleView = segmentedControl

    view.addSubview(collectionView)
    collectionView.fill()
    collectionView.backgroundColor = .mainBackground
    collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    collectionView.delaysContentTouches = false

  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: { _ in
        self.collectionView.collectionViewLayout.invalidateLayout()
    })
  }
  
  deinit {
    likeNotificationToken?.invalidate()
    dislikeNotificationToken?.invalidate()
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

extension LoveViewController: UICollectionViewDataSource {
  
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int)
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
    cell.decorate(
      model: .init(
        imageURL: imageURL(from: wine.wineID).toURL,
        titleText: wine.title,
        subtitleText: nil))
    return cell
  }
}

extension LoveViewController: UICollectionViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath) {
    
    guard let wine = wines[safe: indexPath.row] else { return }
    navigationController?.pushViewController(Assembly.buildDetailModule(wineID: wine.wineID), animated: true)
  }
}

extension LoveViewController: ErrorViewDelegate {
  
  func didTapErrorButton(_ button: UIButton) {
    tabBarController?.selectedIndex = 0
  }
}
