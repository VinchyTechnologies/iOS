//
//  ResultsSearchViewController.swift
//  Smart
//
//  Created by Михаил Исаченко on 23.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import DisplayMini
import EpoxyBars
import EpoxyCollectionView
import EpoxyCore
import StringFormatting
import UIKit
import VinchyCore
import VinchyUI

// MARK: - ResultsSearchViewController

final class ResultsSearchViewController: UIViewController {

  // MARK: Lifecycle

  init(input: ResultsSearchInput) {
    self.input = input
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  var interactor: ResultsSearchInteractorProtocol?

  weak var didnotFindTheWineCollectionCellDelegate: DidnotFindTheWineCollectionCellProtocol?
  weak var resultsSearchDelegate: ResultsSearchDelegate?

  override func viewDidLoad() {
    super.viewDidLoad()

    switch input.mode {
    case .normal:
      view.addSubview(collectionView)
      collectionView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      ])
      collectionView.backgroundColor = .mainBackground

    case .storeDetail:
      collectionView.backgroundColor = .clear
      view.backgroundColor = .clear
      view.addSubview(blurEffectView)
      blurEffectView.translatesAutoresizingMaskIntoConstraints = false
      blurEffectView.constrainToSuperview()

      topBarInstaller.install()
      if let container = topBarInstaller.container {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
          collectionView.topAnchor.constraint(equalTo: container.bottomAnchor),
          collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
          collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
      }
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if input.shouldHideNavigationController {
      navigationController?.setNavigationBarHidden(true, animated: false)
    }
    interactor?.viewWillAppear()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    if input.shouldHideNavigationController {
      navigationController?.setNavigationBarHidden(false, animated: true)
    }
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

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    let blurEffect = UIBlurEffect(style: traitCollection.userInterfaceStyle == .dark ? .dark : .light)
    blurEffectView.effect = blurEffect
  }

  // MARK: Private

  private lazy var collectionViewSize: CGSize = view.frame.size

  private lazy var blurEffectView = UIVisualEffectView()

  private lazy var topBarInstaller = TopBarInstaller(
    viewController: self,
    bars: bars)

  private let input: ResultsSearchInput

  private let layout = UICollectionViewFlowLayout()

  private lazy var collectionView: CollectionView = {
    let collectionView = CollectionView(layout: layout)
    collectionView.delaysContentTouches = false
    collectionView.keyboardDismissMode = .onDrag
    return collectionView
  }()

  private var viewModel: ResultsSearchViewModel = .empty

  @SectionModelBuilder
  private var sections: [SectionModel] {
    viewModel.sections.compactMap { section in
      switch section {
      case .title(let content):
        let width: CGFloat = collectionViewSize.width - 48
        let style = Label.Style.style(with: .lagerTitle)
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
        .flowLayoutSectionInset(.init(top: 8, left: 24, bottom: 8, right: 24))

      case .recentlySearched(let content):
        return SectionModel(dataID: UUID()) {
          BottlesCollectionView.itemModel(
            dataID: UUID(),
            content: content,
            style: .init())
            .setBehaviors({ [weak self] context in
              context.view.bottlesCollectionViewDelegate = self
            })
        }
        .flowLayoutItemSize(.init(width: collectionViewSize.width, height: 250))
        .flowLayoutSectionInset(.init(top: 0, left: 0, bottom: 16, right: 0))

      case .horizontalWine(let content):
        let style = HorizontalWineView.Style(id: UUID(), kind: content.buttonText.isNilOrEmpty ? .common : .price)
        return SectionModel(dataID: UUID()) {
          HorizontalWineView.itemModel(
            dataID: UUID(),
            content: content,
            behaviors: .init(didTap: { [weak self] _, wineID in
              self?.interactor?.didSelectHorizontalWine(wineID: wineID)
              self?.resultsSearchDelegate?.didTapBottleCell(wineID: wineID)
            }),
            style: style)
            .didSelect { [weak self] _ in
              self?.interactor?.didSelectHorizontalWine(wineID: content.wineID)
              self?.resultsSearchDelegate?.didTapBottleCell(wineID: content.wineID)
            }
        }
        .flowLayoutItemSize(.init(width: collectionViewSize.width, height: content.height(width: collectionViewSize.width, style: style)))

      case .didnotFindWine(let content):
        return SectionModel(dataID: UUID()) {
          DidnotFindTheWineView.itemModel(
            dataID: UUID(),
            content: content,
            style: .init())
            .setBehaviors({ [weak self] context in
              context.view.delegate = self?.didnotFindTheWineCollectionCellDelegate
            })
        }
        .flowLayoutItemSize(.init(width: collectionViewSize.width - 48, height: 65))
        .flowLayoutSectionInset(.init(top: 0, left: 24, bottom: 0, right: 24))
      }
    }
  }

  @BarModelBuilder
  private var bars: [BarModeling] {
    [
      SearchBar.barModel(
        dataID: nil,
        content: .init(),
        behaviors: .init(didTapCancel: { [weak self] in
          self?.dismiss(animated: true)
        }, didEnterSearchText: { [weak self] searchText in
          self?.interactor?.didEnterSearchText(searchText)
        }),
        style: .init())
        .willDisplay { context in
          context.view.searchBar.becomeFirstResponder()
        },
    ]
  }
}

// MARK: ResultsSearchViewControllerProtocol

extension ResultsSearchViewController: ResultsSearchViewControllerProtocol {
  func updateUI(viewModel: ResultsSearchViewModel) {
    self.viewModel = viewModel
    collectionView.contentOffset = .zero
    collectionView.setSections(sections, animated: false)
  }
}

// MARK: BottlesCollectionViewDelegate

extension ResultsSearchViewController: BottlesCollectionViewDelegate {
  func didTapShareContextMenu(wineID: Int64, sourceView: UIView) {
  }

  func didTapWriteNoteContextMenu(wineID: Int64) {
  }

  func didTap(wineID: Int64) {
    interactor?.didTapHistoryWine(wineID: wineID)
    resultsSearchDelegate?.didTapBottleCell(wineID: wineID)
  }

  func didTapPriceButton(_ button: UIButton, wineID: Int64) {
    interactor?.didTapHistoryWine(wineID: wineID)
    resultsSearchDelegate?.didTapBottleCell(wineID: wineID)
  }

  func bottlesScrollViewDidScroll(_ scrollView: UIScrollView) {
  }
}

// MARK: UISearchBarDelegate

extension ResultsSearchViewController: UISearchBarDelegate {

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    collectionView.contentOffset = .zero
    dismiss(animated: true)
  }

  func searchBar(
    _: UISearchBar,
    textDidChange searchText: String)
  {
    interactor?.didEnterSearchText(searchText)
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    resultsSearchDelegate?.didTapSearchButton(searchText: searchBar.text)
  }
}
