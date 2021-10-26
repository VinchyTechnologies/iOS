//
//  FakeVinchyCollectionCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 22.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Display
import Epoxy
import UIKit

// MARK: - FakeVinchyCollectionCellType

enum FakeVinchyCollectionCellType: Equatable {
  case stories(count: Int)
  case promo(count: Int)
  case title(count: Int)
  case big(count: Int)
}

// MARK: - FakeVinchyCollectionCellViewModel

struct FakeVinchyCollectionCellViewModel: Equatable {

  fileprivate let type: FakeVinchyCollectionCellType

  public init(type: FakeVinchyCollectionCellType) {
    self.type = type
  }
}

// MARK: - FakeVinchyCollectionCell

final class FakeVinchyCollectionCell: UIView, EpoxyableView {

  // MARK: Lifecycle

  init(style: Style) {
    self.style = style
    super.init(frame: .zero)

    addSubview(collectionView)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
      collectionView.topAnchor.constraint(equalTo: topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  struct Style: Hashable {
  }

  typealias Content = FakeVinchyCollectionCellViewModel

  static func height(viewModel: FakeVinchyCollectionCellViewModel?) -> CGFloat {
    guard let type = viewModel?.type else {
      return 0
    }

    switch type {
    case .stories:
      return 135

    case .promo:
      return 120

    case .title:
      return 25

    case .big:
      return 150
    }
  }

  func setContent(_ content: Content, animated: Bool) {
    type = content.type
  }

  // MARK: Private

  private let style: Style

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
    collectionView.register(FakeCell.self)
    collectionView.delaysContentTouches = false
    collectionView.isScrollEnabled = false
    collectionView.isUserInteractionEnabled = false
    return collectionView
  }()

  private var type: FakeVinchyCollectionCellType? {
    didSet {
      collectionView.reloadData()
    }
  }
}

// MARK: UICollectionViewDataSource

extension FakeVinchyCollectionCell: UICollectionViewDataSource {
  func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
    guard let type = type else { return 0 }
    switch type {
    case .stories(let count), .promo(let count), .title(let count), .big(let count):
      return count
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell
  {
    switch type {
    case .stories, .title, .big, .promo:
      // swiftlint:disable:next force_cast
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FakeCell.reuseId, for: indexPath) as! FakeCell
      cell.layer.cornerRadius = 12
      cell.clipsToBounds = true
      return cell

    case .none:
      fatalError()
    }
  }
}

// MARK: UICollectionViewDelegateFlowLayout

extension FakeVinchyCollectionCell: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout _: UICollectionViewLayout,
    sizeForItemAt _: IndexPath)
    -> CGSize
  {
    guard let type = type else { return .zero }
    switch type {
    case .stories:
      return .init(width: 135, height: collectionView.frame.height)

    case .promo:
      return .init(width: UIScreen.main.bounds.width - 60, height: collectionView.frame.height)

    case .title:
      return .init(width: UIScreen.main.bounds.width / 3, height: collectionView.frame.height)

    case .big:
      return .init(width: UIScreen.main.bounds.width - 100, height: collectionView.frame.height)
    }
  }
}
