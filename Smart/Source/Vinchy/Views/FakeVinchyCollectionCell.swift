//
//  FakeVinchyCollectionCell.swift
//  Smart
//
//  Created by Aleksei Smirnov on 22.11.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import Display

enum FakeVinchyCollectionCellType {
  case stories(count: Int)
  case promo(count: Int)
  case title(count: Int)
  case big(count: Int)
}

struct FakeVinchyCollectionCellViewModel: ViewModelProtocol {

  fileprivate let type: FakeVinchyCollectionCellType

  public init(type: FakeVinchyCollectionCellType) {
    self.type = type
  }
}

final class FakeVinchyCollectionCell: UICollectionViewCell, Reusable {

  private var type: FakeVinchyCollectionCellType? {
    didSet {
      collectionView.reloadData()
    }
  }

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

  required init?(coder: NSCoder) { fatalError() }

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
      return 250
    }
  }
}

extension FakeVinchyCollectionCell: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
    switch self.type {
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

extension FakeVinchyCollectionCell: UICollectionViewDelegateFlowLayout {

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath)
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

extension FakeVinchyCollectionCell: Decoratable {

  typealias ViewModel = FakeVinchyCollectionCellViewModel

  func decorate(model: ViewModel) {
    self.type = model.type
  }
}
