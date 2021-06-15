//
//  VinchySimpleConiniousCaruselCollectionCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 02.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Display
import StringFormatting
import UIKit
import VinchyCore

// MARK: - VinchySimpleConiniousCaruselCollectionCellDelegate

protocol VinchySimpleConiniousCaruselCollectionCellDelegate: AnyObject {
  func didTapBottleCell(wineID: Int64)
  func didTapCompilationCell(wines: [ShortWine], title: String?)
}

// MARK: - VinchySimpleConiniousCaruselCollectionCellViewModel

struct VinchySimpleConiniousCaruselCollectionCellViewModel: ViewModelProtocol {
  fileprivate let type: CollectionType
  fileprivate let collections: [Collection]

  public init(type: CollectionType, collections: [Collection]) {
    self.type = type
    self.collections = collections
  }
}

// MARK: - VinchySimpleConiniousCaruselCollectionCell

final class VinchySimpleConiniousCaruselCollectionCell: UICollectionViewCell, Reusable {

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

  // MARK: Internal

  weak var delegate: VinchySimpleConiniousCaruselCollectionCellDelegate?

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
    return collectionView
  }()

  private var collections: [Collection] = [] {
    didSet {
      collectionView.reloadData()
    }
  }
}

// MARK: UICollectionViewDataSource

extension VinchySimpleConiniousCaruselCollectionCell: UICollectionViewDataSource {
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

extension VinchySimpleConiniousCaruselCollectionCell: UICollectionViewDelegateFlowLayout {
  func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch type {
    case .mini, .big, .promo:
      delegate?.didTapCompilationCell(wines: collections[indexPath.row].wineList.compactMap { collectionItem -> ShortWine? in
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
        delegate?.didTapBottleCell(wineID: wine.id)
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

// MARK: Decoratable

extension VinchySimpleConiniousCaruselCollectionCell: Decoratable {
  typealias ViewModel = VinchySimpleConiniousCaruselCollectionCellViewModel

  func decorate(model: ViewModel) {
    type = model.type
    collections = model.collections
  }
}
