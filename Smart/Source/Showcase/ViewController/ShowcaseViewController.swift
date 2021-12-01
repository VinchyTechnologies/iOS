//
//  ShowcaseViewController.swift
//  StartUp
//
//  Created by Aleksei Smirnov on 07.04.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Database
import Display
import StringFormatting
import UIKit
import VinchyCore
import VinchyUI

// MARK: - C

private enum C {
  static let limit: Int = 40
  static let inset: CGFloat = 10
}

// MARK: - ShowcaseViewController

final class ShowcaseViewController: UIViewController, UICollectionViewDelegate, Loadable {

  // MARK: Lifecycle

  init(input: ShowcaseInput) {
    self.input = input
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Internal

  var interactor: ShowcaseInteractorProtocol?

  private(set) var loadingIndicator = ActivityIndicatorView()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .mainBackground
    navigationItem.largeTitleDisplayMode = .never

    if isModal {
      let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .default)
      navigationItem.leftBarButtonItem = UIBarButtonItem(
        image: UIImage(systemName: "xmark", withConfiguration: imageConfig),
        style: .plain,
        target: self,
        action: #selector(didTapCloseBarButtonItem(_:)))
    }

    view.addSubview(tabView)
    tabView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      tabView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tabView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      tabView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      tabView.heightAnchor.constraint(equalToConstant: 56),
    ])

    view.addSubview(collectionView)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: tabView.bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])

    interactor?.viewDidLoad()
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: { _ in
      self.collectionView.collectionViewLayout.invalidateLayout()
    })
  }

  // MARK: Private

  private lazy var tabView: TabView = {
    $0.delegate = self
    return $0
  }(TabView())
  private lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.isPrefetchingEnabled = true
    collectionView.prefetchDataSource = self
    collectionView.backgroundColor = .clear
    collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    collectionView.register(WineCollectionViewCell.self, LoadingIndicatorCell.self)
    collectionView.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableView.reuseId)
    collectionView.delaysContentTouches = false
    collectionView.contentInset = .init(top: 0, left: 0, bottom: 10, right: 0)
    return collectionView
  }()

  private let layout: UICollectionViewFlowLayout = {
    let layout = UICollectionViewFlowLayout()
    layout.sectionHeadersPinToVisibleBounds = false
    layout.sectionInset = UIEdgeInsets(top: 0, left: C.inset, bottom: 0, right: C.inset)
    layout.minimumLineSpacing = C.inset
    layout.minimumInteritemSpacing = 0
    return layout
  }()

  private let input: ShowcaseInput

  private var viewModel: ShowcaseViewModel? {
    didSet {
      navigationItem.title = viewModel?.navigationTitle
      if let tabViewModel = viewModel?.tabViewModel {
        if tabViewModel != oldValue?.tabViewModel {
          tabView.configure(with: tabViewModel)
        }
      }
      collectionView.reloadData()
    }
  }

  private func updateShadowSupplementaryHeaderView(offset: CGFloat) {
    let value: CGFloat = offset
    let alpha = min(1, max(0, value / 10))
    tabView.layer.shadowOpacity = Float(alpha / 2.0)
  }

  @objc
  private func didTapCloseBarButtonItem(_: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }

  private func hideErrorView() {
    DispatchQueue.main.async {
      self.collectionView.backgroundView = nil
    }
  }
}

// MARK: UICollectionViewDataSource

extension ShowcaseViewController: UICollectionViewDataSource {
  func numberOfSections(in _: UICollectionView) -> Int {
    viewModel?.sections.count ?? 0
  }

  func collectionView(
    _: UICollectionView,
    numberOfItemsInSection section: Int)
    -> Int
  {
    switch viewModel?.sections[safe: section] {
    case .shelf(_, let model):
      return model.count

    case .loading:
      return 1

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
    case .shelf(_, let model):
      // swiftlint:disable:next force_cast
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WineCollectionViewCell.reuseId, for: indexPath) as! WineCollectionViewCell
      cell.decorate(model: model[indexPath.row])
      return cell

    case .loading:
      // swiftlint:disable:next force_cast
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingIndicatorCell.reuseId, for: indexPath) as! LoadingIndicatorCell
      return cell

    case .none:
      return .init()
    }
  }

  func collectionView(
    _: UICollectionView,
    willDisplay _: UICollectionViewCell,
    forItemAt indexPath: IndexPath)
  {
    switch input.mode {
    case .normal:
      break

    case .advancedSearch, .partner:
      switch viewModel?.sections[safe: indexPath.section] {
      case .loading:
        interactor?.willDisplayLoadingView()

      case .shelf, .none:
        break
      }
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath)
    -> UICollectionReusableView
  {
    switch kind {
    case UICollectionView.elementKindSectionHeader:
      switch viewModel?.sections[safe: indexPath.section] {
      case .shelf(let model, _):
        // swiftlint:disable:next force_cast
        let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderReusableView.reuseId, for: indexPath) as! HeaderReusableView
        reusableview.decorate(model: .init(title: model))
        return reusableview

      case .loading, .none:
        return .init()
      }

    default:
      return .init()
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout _: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int)
    -> CGSize
  {
    if case .loading = viewModel?.sections[section] {
      return .zero
    }
    return .init(width: collectionView.frame.width, height: 48)
  }
}

// MARK: UICollectionViewDelegateFlowLayout

extension ShowcaseViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch viewModel?.sections[safe: indexPath.section] {
    case .shelf(_, let wines):
      interactor?.didSelectWine(wineID: wines[indexPath.row].wineID)

    case .loading, .none:
      break
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout _: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath)
    -> CGSize
  {
    switch viewModel?.sections[safe: indexPath.section] {
    case .shelf:
      let rowCount: Int = {
        if UIDevice.current.userInterfaceIdiom == .pad {
          if Orientation.isLandscape {
            return 4
          } else {
            return 3
          }
        } else {
          return 2
        }
      }()

      let itemWidth = Int((UIScreen.main.bounds.width - C.inset * CGFloat(rowCount + 1)) / CGFloat(rowCount))
      let itemHeight = Int(Double(itemWidth) * 1.5)
      return CGSize(width: itemWidth, height: itemHeight)

    case .loading:
      return .init(width: collectionView.frame.width, height: 48)

    case .none:
      return .zero
    }
  }
}

// MARK: ShowcaseViewControllerProtocol

extension ShowcaseViewController: ShowcaseViewControllerProtocol {
  func updateUI(viewModel: ShowcaseViewModel) {
    hideErrorView()
    self.viewModel = viewModel
  }

  func updateUI(errorViewModel: ErrorViewModel) {
    DispatchQueue.main.async {
      let errorView = ErrorView(frame: self.view.frame)
      errorView.decorate(model: errorViewModel)
      errorView.delegate = self
      self.collectionView.backgroundView = errorView
    }
  }
}

// MARK: ErrorViewDelegate

extension ShowcaseViewController: ErrorViewDelegate {
  func didTapErrorButton(_: UIButton) {
    interactor?.viewDidLoad() // TODO: - not viewdidload
  }
}

// MARK: UICollectionViewDataSourcePrefetching

extension ShowcaseViewController: UICollectionViewDataSourcePrefetching {

  func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
    var urls: [URL] = []
    indexPaths.forEach { indexPath in
      switch viewModel?.sections[indexPath.section] {
      case .shelf(_, let wines):
        if let wine = wines[safe: indexPath.row], let url = imageURL(from: wine.wineID).toURL {
          urls.append(url)
        }

      case .loading, .none:
        break
      }
    }
    ImageLoader.shared.prefetch(Array(Set(urls)))
  }

  func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
    var urls: [URL] = []
    indexPaths.forEach { indexPath in
      switch viewModel?.sections[indexPath.section] {
      case .shelf(_, let wines):
        if let wine = wines[safe: indexPath.row], let url = imageURL(from: wine.wineID).toURL {
          urls.append(url)
        }

      case .loading, .none:
        break
      }
    }
    ImageLoader.shared.cancelPrefetch(Array(Set(urls)))
  }
}

// MARK: TabViewDelegate

extension ShowcaseViewController: TabViewDelegate {
  func tabView(_ view: TabView, didSelect item: TabItemViewModel, atIndex index: Int) {
    guard
      let rect = collectionView.layoutAttributesForSupplementaryElement(
        ofKind: UICollectionView.elementKindSectionHeader,
        at: IndexPath(item: 0, section: index))?.frame
    else {
      return
    }
    let offset = CGPoint(x: .zero, y: rect.minY)
    collectionView.setContentOffset(offset, animated: true)
  }
}

// MARK: UIScrollViewDelegate

extension ShowcaseViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView === collectionView {
      if scrollView.isDecelerating || scrollView.isDragging {
        let visiblePaths = collectionView.indexPathsForVisibleItems.sorted(by: { $0.section < $1.section || $0.row < $1.row })
        guard let indexPath = visiblePaths.first else { return }
        tabView.selectItem(atIndex: indexPath.section, animated: true)
      }
      updateShadowSupplementaryHeaderView(offset: scrollView.contentOffset.y)
    }
  }
}
