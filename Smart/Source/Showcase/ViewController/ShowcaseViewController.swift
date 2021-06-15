//
//  ShowcaseViewController.swift
//  StartUp
//
//  Created by Aleksei Smirnov on 07.04.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import Display
import StringFormatting
import UIKit
import VinchyCore

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

  // MARK: - Private Properties

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

    view.addSubview(collectionView)
    collectionView.fill()

    interactor?.viewDidLoad()
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: { _ in
      self.collectionView.collectionViewLayout.invalidateLayout()
    })
  }

  // MARK: Private

  private lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.dataSource = self
    collectionView.delegate = self
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
    layout.sectionHeadersPinToVisibleBounds = true
    layout.sectionInset = UIEdgeInsets(top: 0, left: C.inset, bottom: 0, right: C.inset)
    layout.minimumLineSpacing = C.inset
    layout.minimumInteritemSpacing = 0
    return layout
  }()

  private let input: ShowcaseInput

  private var viewModel: ShowcaseViewModel? {
    didSet {
      navigationItem.title = viewModel?.navigationTitle
      collectionView.reloadData()
    }
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
    interactor?.viewDidLoad()
  }
}
