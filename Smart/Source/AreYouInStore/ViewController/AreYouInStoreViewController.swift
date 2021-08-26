//
//  AreYouInStoreViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 30.06.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Display
import FittedSheets
import UIKit

// MARK: - AreYouInStoreViewController

final class AreYouInStoreViewController: UIViewController {

  // MARK: Internal

  var interactor: AreYouInStoreInteractorProtocol?

  static func height(viewModel: AreYouInStoreViewModel) -> CGFloat {
    var height: CGFloat = 0.0
    viewModel.sections.forEach { section in
      switch section {
      case .title(let model):
        model.forEach { textModel in
          height += TextCollectionCell.height(viewModel: textModel, width: UIScreen.main.bounds.width - 32)
        }

      case .recommendedWines:
        height += 250
      }
    }

    let bottomViewHeight: CGFloat = (UIApplication.shared.asKeyWindow?.safeAreaInsets.bottom ?? 0) + 48 + 20 + 10

    return height + bottomViewHeight + 24 /* pull bar height */
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let bottomViewHeight = (UIApplication.shared.asKeyWindow?.safeAreaInsets.bottom ?? 0) + 48 + 20
//    collectionView.contentInset.bottom = bottomViewHeight + 10

    view.addSubview(bottomButtonsView)
    bottomButtonsView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      bottomButtonsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      bottomButtonsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      bottomButtonsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      bottomButtonsView.heightAnchor.constraint(equalToConstant: bottomViewHeight),
    ])

    view.addSubview(collectionView)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 24/* pull bar height */),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomButtonsView.topAnchor, constant: -10),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])

    sheetViewController?.handleScrollView(collectionView)

    interactor?.viewDidLoad()
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: { _ in
      self.collectionView.collectionViewLayout.invalidateLayout()
    })
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
//    collectionView.layoutIfNeeded()
  }

  // MARK: Private

  private lazy var bottomButtonsView: BottomButtonsView = {
//    $0.delegate = self
    $0
  }(BottomButtonsView())

  private let layout: UICollectionViewFlowLayout = {
    $0.scrollDirection = .vertical
    return $0
  }(UICollectionViewFlowLayout())

  private lazy var collectionView: UICollectionView = {
    $0.backgroundColor = .mainBackground
    $0.delaysContentTouches = false
    $0.dataSource = self
    $0.delegate = self
    $0.register(
      TextCollectionCell.self,
      SimpleContinuousCaruselCollectionCellView.self)
    return $0
  }(UICollectionView(frame: .zero, collectionViewLayout: layout))

  private var viewModel: AreYouInStoreViewModel? {
    didSet {
      guard let viewModel = viewModel else { return }
      bottomButtonsView.decorate(model: viewModel.bottomButtonsViewModel)
      collectionView.reloadData()
    }
  }

}

// MARK: UICollectionViewDataSource

extension AreYouInStoreViewController: UICollectionViewDataSource {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    viewModel?.sections.count ?? 0
  }

  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int)
    -> Int
  {
    switch viewModel?.sections[safe: section] {
    case .title(let model):
      return model.count

    case .recommendedWines(let model):
      return model.count

    case .none:
      return 0
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell
  {
    switch viewModel?.sections[safe: indexPath.section] {

    case .title(let model):
      // swiftlint:disable:next force_cast
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCollectionCell.reuseId, for: indexPath) as! TextCollectionCell
      cell.decorate(model: model[indexPath.row])
      return cell

    case .recommendedWines(let model):
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: SimpleContinuousCaruselCollectionCellView.reuseId,
        for: indexPath) as! SimpleContinuousCaruselCollectionCellView // swiftlint:disable:this force_cast
      let configurator = SimpleContinuosCarouselCollectionCellConfigurator(delegate: nil)
      configurator.configure(view: cell, with: SimpleContinuosCarouselCollectionCellInput(model: model[indexPath.row]))
      cell.viewDidLoad()
      return cell

    case .none:
      return .init()
    }
  }
}

// MARK: UICollectionViewDelegateFlowLayout

extension AreYouInStoreViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath)
    -> CGSize
  {
    switch viewModel?.sections[safe: indexPath.section] {
    case .title(let model):
      let width = collectionView.frame.width - 32
      let height = TextCollectionCell.height(viewModel: model[indexPath.row], width: width)
      return .init(width: width, height: height)

    case .recommendedWines:
      return .init(width: collectionView.frame.width, height: 250)

    case .none:
      return .zero
    }
  }
}

// MARK: AreYouInStoreViewControllerProtocol

extension AreYouInStoreViewController: AreYouInStoreViewControllerProtocol {
  func updateUI(viewModel: AreYouInStoreViewModel) {
    self.viewModel = viewModel
  }
}
