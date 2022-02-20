//
//  OrdersViewController.swift
//  VinchyOrder
//
//  Created by Алексей Смирнов on 20.02.2022.
//

import DisplayMini
import EpoxyCollectionView
import UIKit

// MARK: - C

fileprivate enum C {
  static let horizontalInset: CGFloat = 16
}

// MARK: - OrdersViewController

final class OrdersViewController: CollectionViewController {

  // MARK: Lifecycle

  init() {
    let layout = SeparatorFlowLayout()
    super.init(layout: layout)
    layout.delegate = self
  }

  // MARK: Internal

  var interactor: OrdersInteractorProtocol?

  private(set) var loadingIndicator = ActivityIndicatorView()

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.largeTitleDisplayMode = .never
    interactor?.viewDidLoad()
  }

  override func makeCollectionView() -> CollectionView {
    CollectionView(layout: layout, configuration: .init(usesBatchUpdatesForAllReloads: false, usesCellPrefetching: false, usesAccurateScrollToItem: true))
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    if UIApplication.shared.applicationState != .background {
      coordinator.animate(alongsideTransition: { _ in
        self.collectionViewSize = size
        self.collectionView.setSections(self.sections, animated: false)
      })
    }
  }

  // MARK: Private

  private lazy var collectionViewSize: CGSize = view.frame.size

  private var viewModel: OrdersViewModel = .empty

  @SectionModelBuilder
  private var sections: [SectionModel] {
    switch viewModel.state {
    case .normal(let sections):
      sections.compactMap { section in
        switch section {
        case .content(_, let items):
          return SectionModel(dataID: UUID()) {
            items.compactMap { item in
              switch item {
              case .order(let content):
                let width: CGFloat = collectionViewSize.width - 2 * C.horizontalInset
                let height: CGFloat = 64
                return OrderView.itemModel(dataID: UUID(), content: content, style: .init())
                  .flowLayoutItemSize(.init(width: width, height: height))

              case .loading:
                return LoadingView.itemModel(dataID: UUID())
                  .willDisplay { [weak self] _ in
                    self?.interactor?.willDisplayLoadingView()
                  }
                  .flowLayoutItemSize(.init(width: collectionViewSize.width, height: LoadingView.height))
              }
            }
          }
        }
      }

    case .error(let sections):
      sections.compactMap { section in
        switch section {
        case .common(let content):
          let height = collectionViewSize.height
            - (navigationController?.navigationBar.frame.height ?? 0)
            - (UIApplication.shared.asKeyWindow?.layoutMargins.top ?? 0)
            - (UIApplication.shared.asKeyWindow?.layoutMargins.bottom ?? 0)
          return SectionModel(dataID: UUID()) {
            EpoxyErrorView.itemModel(
              dataID: UUID(),
              content: content,
              style: .init())
              .setBehaviors { [weak self] context in
                guard let self = self else { return }
                context.view.delegate = self
              }
          }
          .flowLayoutItemSize(.init(width: collectionViewSize.width, height: height))
          .flowLayoutSectionInset(.init(top: 0, left: 0, bottom: 0, right: 0))
          .flowLayoutHeaderReferenceSize(.zero)
        }
      }
    }
  }
}

// MARK: OrdersViewControllerProtocol

extension OrdersViewController: OrdersViewControllerProtocol {
  func updateUI(viewModel: OrdersViewModel) {
    self.viewModel = viewModel
    navigationItem.title = viewModel.navigationTitle
    setSections(sections, animated: true)
  }
}

// MARK: EpoxyErrorViewDelegate

extension OrdersViewController: EpoxyErrorViewDelegate {
  func didTapErrorButton(_ button: UIButton) {
    interactor?.viewDidLoad()
  }
}

// MARK: SeparatorFlowLayoutDelegate

extension OrdersViewController: SeparatorFlowLayoutDelegate {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: SeparatorFlowLayout, shouldShowSeparatorBelowItemAt indexPath: IndexPath) -> Bool {
    true
//    switch viewModel.state {
//    case .normal(let sections):
//      let section = sections[safe: indexPath.section]
//      switch section {
//      case .content(_, let items):
//        let item = items[safe: indexPath.item]
//        switch item {
//        case .order:
//          return true
//
//        case .title, .loading, .none:
//          return false
//        }
//
//      case .none:
//        return false
//      }
//
//    case .error:
//      return false
//    }
  }
}
