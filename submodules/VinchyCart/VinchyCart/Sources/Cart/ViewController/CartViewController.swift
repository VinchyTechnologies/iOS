//
//  CartViewController.swift
//  VinchyCart
//
//  Created by Алексей Смирнов on 11.02.2022.
//

import DisplayMini
import EpoxyBars
import EpoxyCollectionView
import UIKit

// MARK: - CartViewController

final class CartViewController: CollectionViewController {

  // MARK: Lifecycle

  init() {
    let layout = UICollectionViewFlowLayout()
    super.init(layout: layout)
  }

  // MARK: Internal

  var interactor: CartInteractorProtocol?

  override func viewDidLoad() {
    super.viewDidLoad()
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .default)

    if isModal {
      navigationItem.leftBarButtonItem = UIBarButtonItem(
        image: UIImage(systemName: "chevron.down", withConfiguration: imageConfig),
        style: .plain,
        target: self,
        action: #selector(didTapCloseBarButtonItem(_:)))
    }

    navigationItem.largeTitleDisplayMode = .never

    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash.fill", withConfiguration: imageConfig)?.withTintColor(.systemRed, renderingMode: .alwaysOriginal), style: .plain, target: self, action: nil)
    bottomBarInstaller.install()
    interactor?.viewDidLoad()
  }
  override func makeCollectionView() -> CollectionView {
    let collectionView = super.makeCollectionView()
    collectionView.backgroundColor = .mainBackground
    collectionView.delaysContentTouches = false
    return collectionView
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    if UIApplication.shared.applicationState != .background {
      coordinator.animate(alongsideTransition: { _ in
        self.collectionViewSize = size
        self.setSections(self.sections, animated: false)
      })
    }
  }

  // MARK: Private

  private lazy var collectionViewSize: CGSize = view.frame.size

  private var viewModel: CartViewModel = .empty

  private lazy var bottomBarInstaller = BottomBarInstaller(
    viewController: self,
    bars: bars)

  @SectionModelBuilder
  private var sections: [SectionModel] {
    viewModel.sections.compactMap { section in
      switch section {
      case .logo(let content):
        let width = collectionViewSize.width - 48
        return SectionModel(dataID: UUID()) {
          LogoRow.itemModel(
            dataID: UUID(),
            content: content,
            style: .large)
        }
        .flowLayoutSectionInset(.init(top: 0, left: 24, bottom: 8, right: 24))
        .flowLayoutItemSize(.init(width: width, height: content.height(for: width)))

      case .address(let content):
        let width: CGFloat = collectionViewSize.width - 48
        let height: CGFloat = content.height(for: width)
        return SectionModel(dataID: UUID()) {
          StoreMapRow.itemModel(
            dataID: UUID(),
            content: content,
            style: .init())
        }
        .flowLayoutItemSize(.init(width: width, height: height))
        .flowLayoutSectionInset(.init(top: 0, left: 24, bottom: 8, right: 24))

      case .title(let content):
        let width: CGFloat = collectionViewSize.width - 48
        let style = Label.Style.style(with: .lagerTitle, textAligment: .right)
        let height: CGFloat = Label.height(
          for: content,
          width: width,
          style: style)
        return SectionModel(dataID: UUID()) {
          Label.itemModel(
            dataID: UUID(),
            content: content,
            style: style)
        }
        .flowLayoutItemSize(.init(width: width, height: height))
        .flowLayoutSectionInset(.init(top: 0, left: 24, bottom: 8, right: 24))

      case .cartItem(let content):
        return SectionModel(dataID: UUID()) {
          CartItemView.itemModel(
            dataID: UUID(),
            content: content,
            style: .init(id: UUID()))
            .didSelect { [weak self] _ in
//            self?.interactor?.didSelectHorizontalWine(wineID: content.wineID)
            }
            .flowLayoutItemSize(.init(width: collectionViewSize.width, height: content.height(width: collectionViewSize.width, style: .init(id: UUID()))))
        }
      }
    }
  }


  @BarModelBuilder
  private var bars: [BarModeling] {
    if let bottomPriceBarViewModel = viewModel.bottomBarViewModel {
      [
        BottomPriceBarView.barModel(
          dataID: nil,
          content: bottomPriceBarViewModel,
          behaviors: .init(didSelect: { [weak self] _ in
            //            self?.interactor?.didTapConfirmOrderButton()
          }),
          style: .init(kind: .buttonOnly)),
      ]
    } else {
      []
    }
  }

  @objc
  private func didTapCloseBarButtonItem(_ barButtonItem: UIBarButtonItem) {
    dismiss(animated: true)
  }
}

// MARK: CartViewControllerProtocol

extension CartViewController: CartViewControllerProtocol {

  func updateUI(viewModel: CartViewModel) {
    self.viewModel = viewModel
    navigationItem.title = viewModel.navigationTitleText
    setSections(sections, animated: true)
    bottomBarInstaller.setBars(bars, animated: true)
  }
}
