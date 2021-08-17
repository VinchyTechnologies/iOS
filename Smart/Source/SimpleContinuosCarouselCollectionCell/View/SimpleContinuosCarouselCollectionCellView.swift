//
//  SimpleContinuosCarouselCollectionCellViewController.swift
//  Smart
//
//  Created by Михаил Исаченко on 14.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Database
import Display
import StringFormatting
import UIKit
import VinchyCore

// MARK: - SimpleContinuousCaruselCollectionCellView

final class SimpleContinuousCaruselCollectionCellView: UICollectionViewCell, Reusable {

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

  private var collections: [Collection] = [] {
    didSet {
      collectionView.reloadData()
    }
  }

  private func configureContextMenu(wineID: Int64) -> UIContextMenuConfiguration{
    let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ -> UIMenu? in

      let writeNote = UIAction(title: localized("write_note").firstLetterUppercased(), image: UIImage(systemName: "square.and.pencil"), identifier: nil, discoverabilityTitle: nil, state: .off) { [weak self] _ in
        guard let self = self else { return }
        self.interactor?.didTapWriteNoteContextMenu(wineID: wineID)
      }

      let leaveReview = UIAction(title: localized("write_review").firstLetterUppercased(), image: UIImage(systemName: "text.bubble"), identifier: nil, discoverabilityTitle: nil, state: .off) { [weak self] _ in
        guard let self = self else { return }
        self.interactor?.didTapLeaveReviewContextMenu(wineID: wineID)
      }
      let share = UIAction(title: localized("share_link").firstLetterUppercased(), image: UIImage(systemName: "square.and.arrow.up"), identifier: nil, discoverabilityTitle: nil, state: .off) { [weak self] _ in
        guard let self = self else { return }
        self.interactor?.didTapShareContextMenu(wineID: wineID)
      }

      return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [leaveReview, writeNote, share])
    }
    return context
  }
}

// MARK: UICollectionViewDataSource

extension SimpleContinuousCaruselCollectionCellView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
    switch type {
    case .bottles:
      guard let collection = collections.first, let collectionItem = collection.wineList[safe: indexPath.row] else {
        return nil
      }
      switch collectionItem {
      case .wine(let wine):
        return configureContextMenu(wineID: wine.id)
      case .ads:
        break
      }
    default:
      break
    }
    return nil
  }

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

//extension SimpleContinuousCaruselCollectionCellView: Decoratable {
//  typealias ViewModel = SimpleContinuousCaruselCollectionCellViewModel
//
//  func decorate(model: ViewModel) {
//    type = model.type
//    collections = model.collections
//  }
//}

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
