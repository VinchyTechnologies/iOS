//
//  AddressSearchViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 30.09.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import EpoxyCollectionView
import UIKit

// MARK: - AddressSearchViewController

final class AddressSearchViewController: CollectionViewController {

  // MARK: Lifecycle

  init() {
    let layout = UICollectionViewCompositionalLayout.list
    super.init(layout: layout)
  }

  // MARK: Internal

  var interactor: AddressSearchInteractorProtocol?

  var items: [ItemModeling] {
    viewModel.sections.map({ section in
      switch section {
      case .address(let content):
        return TextRow.itemModel(
          dataID: content.id,
          content: content,
          style: .large)
          .didSelect { [weak self] _ in
//            self?.interactor?.didSelectDocument(documentId: content.id)
          }
      }
    })
  }

  override func makeCollectionView() -> CollectionView {
    let collectionView = super.makeCollectionView()
    collectionView.delaysContentTouches = false
    collectionView.backgroundColor = .mainBackground
    return collectionView
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .default)
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "chevron.down", withConfiguration: imageConfig),
      style: .plain,
      target: self,
      action: #selector(didTapCloseBarButtonItem(_:)))

    view.backgroundColor = .mainBackground
    collectionView.backgroundColor = .mainBackground
    navigationItem.largeTitleDisplayMode = .never

    let searchViewController = UISearchController(searchResultsController: nil)

    searchViewController.showsSearchResultsController = true
    searchViewController.obscuresBackgroundDuringPresentation = false
    searchViewController.searchBar.autocapitalizationType = .none
    searchViewController.searchBar.searchTextField.font = Font.medium(20)
    searchViewController.searchBar.searchTextField.layer.cornerRadius = 20
    searchViewController.searchBar.searchTextField.layer.masksToBounds = true
    searchViewController.searchBar.searchTextField.layer.cornerCurve = .continuous
    searchViewController.searchBar.delegate = self
    searchViewController.hidesNavigationBarDuringPresentation = false

    navigationItem.searchController = searchViewController
    interactor?.viewDidLoad()
  }

  // MARK: Private

  private var viewModel: AddressSearchViewModel = .empty

  @objc
  private func didTapCloseBarButtonItem(_ barButtonItem: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }

}

// MARK: AddressSearchViewControllerProtocol

extension AddressSearchViewController: AddressSearchViewControllerProtocol {
  func updateUI(viewModel: AddressSearchViewModel) {
    self.viewModel = viewModel
    navigationItem.title = viewModel.navigationTitleText
    setItems(items, animated: true)
  }
}

// MARK: UISearchBarDelegate

extension AddressSearchViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    interactor?.didEnterSearchText(searchText)
  }
}
