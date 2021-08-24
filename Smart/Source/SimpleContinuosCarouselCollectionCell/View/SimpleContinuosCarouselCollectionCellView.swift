//
//  SimpleContinuosCarouselCollectionCellViewController.swift
//  Smart
//
//  Created by Михаил Исаченко on 14.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import AudioToolbox
import CommonUI
import CoreHaptics
import Database
import Display
import StringFormatting
import UIKit
import VinchyCore

// MARK: - Constants

private enum Constants {
  static let vibrationSoundId: SystemSoundID = 1519
}

// MARK: - SimpleContinuousCaruselCollectionCellView

final class SimpleContinuousCaruselCollectionCellView: UICollectionViewCell, Reusable, UIGestureRecognizerDelegate {

  // MARK: Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(collectionView)
    NSLayoutConstraint.activate([
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
      collectionView.topAnchor.constraint(equalTo: topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
    setupLongGestureRecognizerOnCollection()
  }
  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Public

  public func viewDidLoad() {
    interactor?.viewDidLoad()
  }

  // MARK: Internal

  private(set) var loadingIndicator = ActivityIndicatorView()

  var interactor: SimpleContinuosCarouselCollectionCellInteractorProtocol?

  static func height(viewModel: ViewModel?) -> CGFloat {
    guard let viewModel = viewModel else {
      return 0
    }

    switch viewModel.type {
    case .mini:
      return 135

    case .big:
      return 155

    case .promo:
      return 120

    case .bottles:
      return 250

    case .shareUs:
      return 160

    case .smartFilter:
      return 250
    }
  }

  // MARK: Private

  private var type: CollectionType?

  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .clear
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(StoryCollectionCell.self, WineCollectionViewCell.self, MainSubtitleCollectionCell.self)
    collectionView.delaysContentTouches = false
    collectionView.prefetchDataSource = self
    collectionView.isPrefetchingEnabled = true
    return collectionView
  }()

  private lazy var hapticGenerator = UISelectionFeedbackGenerator()

  private var collections: [Collection] = [] {
    didSet {
      collectionView.reloadData()
    }
  }

  private func setupLongGestureRecognizerOnCollection() {
    let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
    longPressedGesture.minimumPressDuration = 0.6
    longPressedGesture.delegate = self
    collectionView.addGestureRecognizer(longPressedGesture)
  }

  @objc
  private func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
    if gestureRecognizer.state != .began {
      return
    }

    let point = gestureRecognizer.location(in: collectionView)
    if let indexPath = collectionView.indexPathForItem(at: point) {
      switch type {
      case .bottles:
        guard let collection = collections.first, let collectionItem = collection.wineList[safe: indexPath.row] else {
          return
        }
        switch collectionItem {
        case .wine(let wine):
          if CHHapticEngine.capabilitiesForHardware().supportsHaptics {
            hapticGenerator.selectionChanged()
          } else {
            AudioServicesPlaySystemSound(Constants.vibrationSoundId)
          }
          let cell = collectionView.cellForItem(at: indexPath)!
          let writeNote = ContextMenuItemWithImage(title: localized("write_note").firstLetterUppercased(), image: UIImage(systemName: "square.and.pencil")!) { [weak self] in

            self?.interactor?.didTapWriteNoteContextMenu(wineID: wine.id)
          }
          let leaveReview = ContextMenuItemWithImage(title: localized("write_review").firstLetterUppercased(), image: UIImage(systemName: "text.bubble")!) { [weak self] in

            self?.interactor?.didTapLeaveReviewContextMenu(wineID: wine.id)
          }
          let share = ContextMenuItemWithImage(title: localized("share_link").firstLetterUppercased(), image: UIImage(systemName: "square.and.arrow.up")!) { [weak self] in

            self?.interactor?.didTapShareContextMenu(wineID: wine.id)
          }

          CM.items = [writeNote, leaveReview, share]
          CM.showMenu(viewTargeted: cell, animated: true)
          break
        default:
          break
        }
      default:
        break
      }
    }
  }
}

// MARK: UICollectionViewDataSource

extension SimpleContinuousCaruselCollectionCellView: UICollectionViewDataSource {

  func collectionView(
    _: UICollectionView,
    numberOfItemsInSection _: Int)
    -> Int
  {
    if type == .bottles {
      return collections.first?.wineList.count ?? 0
    }

    return collections.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch type {
    case .mini:
      // swiftlint:disable:next force_cast
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCollectionCell.reuseId, for: indexPath) as! StoryCollectionCell
      cell.decorate(model: .init(imageURL: collections[safe: indexPath.row]?.imageURL?.toURL, titleText: collections[safe: indexPath.row]?.title))
      return cell

    case .big:
      // swiftlint:disable:next force_cast
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainSubtitleCollectionCell.reuseId, for: indexPath) as! MainSubtitleCollectionCell
      cell.decorate(model: .init(subtitleText: collections[safe: indexPath.row]?.title, imageURL: collections[safe: indexPath.row]?.imageURL?.toURL))
      return cell

    case .promo:
      // swiftlint:disable:next force_cast
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainSubtitleCollectionCell.reuseId, for: indexPath) as! MainSubtitleCollectionCell
      cell.decorate(model: .init(subtitleText: collections[safe: indexPath.row]?.title, imageURL: collections[safe: indexPath.row]?.imageURL?.toURL))
      return cell

    case .bottles:
      guard
        let collection = collections.first,
        let collectionItem = collection.wineList[safe: indexPath.row]
      else {
        fatalError()
      }

      switch collectionItem {
      case .wine(let wine):
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WineCollectionViewCell.reuseId, for: indexPath) as! WineCollectionViewCell
        cell.decorate(model: .init(wineID: wine.id, imageURL: wine.mainImageUrl?.toURL, titleText: wine.title, subtitleText: countryNameFromLocaleCode(countryCode: wine.winery?.countryCode)))
        return cell
      case .ads:
        return .init()
      }

    case .none, .shareUs, .smartFilter:
      fatalError()
    }
  }
}


// MARK: UICollectionViewDelegateFlowLayout

extension SimpleContinuousCaruselCollectionCellView: UICollectionViewDelegateFlowLayout {
  func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch type {
    case .mini, .big, .promo:
      interactor?.didTapCompilationCell(wines: collections[indexPath.row].wineList.compactMap { collectionItem -> ShortWine? in
        switch collectionItem {
        case .wine(let wine):
          return wine
        case .ads:
          return nil
        }
      }, title: collections[indexPath.row].title)

    case .bottles:
      guard let collection = collections.first, let collectionItem = collection.wineList[safe: indexPath.row] else {
        return
      }
      switch collectionItem {
      case .wine(let wine):
        interactor?.didTapBottleCell(wineID: wine.id)
      case .ads:
        break
      }

    case .none, .shareUs, .smartFilter:
      break
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout _: UICollectionViewLayout,
    sizeForItemAt _: IndexPath)
    -> CGSize
  {
    let width: CGFloat

    switch type {
    case .mini:
      width = 135

    case .big:
      width = 250

    case .promo:
      width = 290

    case .bottles:
      width = 150

    case .shareUs:
      width = collectionView.frame.width - 32

    case .smartFilter:
      width = collectionView.frame.width - 32

    case .none:
      width = 0
    }

    return .init(width: width, height: collectionView.frame.height)
  }
}

// MARK: UICollectionViewDataSourcePrefetching

extension SimpleContinuousCaruselCollectionCellView: UICollectionViewDataSourcePrefetching {
  func collectionView(
    _ collectionView: UICollectionView,
    prefetchItemsAt indexPaths: [IndexPath])
  {
    var urls: [URL] = []
    indexPaths.forEach { indexPath in
      switch type {
      case .big, .mini, .promo:
        if let url = collections[indexPath.row].imageURL?.toURL {
          urls.append(url)
        }

      case .bottles:
        if
          let collection = collections.first,
          let collectionItem = collection.wineList[safe: indexPath.row]
        {
          switch collectionItem {
          case .wine(let wine):
            if let url = imageURL(from: wine.id).toURL {
              urls.append(url)
            }

          case .ads:
            break
          }
        }

      case .shareUs, .smartFilter, .none:
        break
      }
    }

    ImageLoader.shared.prefetch(urls)
  }

  func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
    var urls: [URL] = []
    indexPaths.forEach { indexPath in
      switch type {
      case .big, .mini, .promo:
        if let url = collections[indexPath.row].imageURL?.toURL {
          urls.append(url)
        }

      case .bottles:
        if
          let collection = collections.first,
          let collectionItem = collection.wineList[safe: indexPath.row]
        {
          switch collectionItem {
          case .wine(let wine):
            if let url = imageURL(from: wine.id).toURL {
              urls.append(url)
            }

          case .ads:
            break
          }
        }

      case .shareUs, .smartFilter, .none:
        break
      }
    }

    ImageLoader.shared.cancelPrefetch(urls)
  }
}

// MARK: SimpleContinuosCarouselCollectionCellViewProtocol

extension SimpleContinuousCaruselCollectionCellView: SimpleContinuosCarouselCollectionCellViewProtocol {

  typealias ViewModel = SimpleContinuousCaruselCollectionCellViewModel

  func showAlert(title: String, message: String) {
    (window?.rootViewController as? Alertable)?.showAlert(title: title, message: message)
  }
  func updateUI(viewModel: ViewModel) {
    type = viewModel.type
    collections = viewModel.collections
  }
}
