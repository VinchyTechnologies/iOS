//
//  DocumentsViewController.swift
//  Smart
//
//  Created by Алексей Смирнов on 04.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Display
import Epoxy

// MARK: - DocumentsViewController

final class DocumentsViewController: CollectionViewController {

  // MARK: Lifecycle

  init() {
    let layout = UICollectionViewCompositionalLayout
      .list
    super.init(layout: layout)
  }

  // MARK: Internal

  var interactor: DocumentsInteractorProtocol?

  var items: [ItemModeling] {
    viewModel.sections.map({ section in
      switch section {
      case .urlDocument(let content):
        return TextRow.itemModel(
          dataID: content.id,
          content: content,
          style: .large)
          .didSelect { [weak self] _ in
            self?.interactor?.didSelectDocument(documentId: content.id)
          }
      }
    })
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.largeTitleDisplayMode = .never
    collectionView.delaysContentTouches = false
    interactor?.viewDidLoad()
  }

  // MARK: Private

  private var viewModel: DocumentsViewModel = .empty

}

// MARK: DocumentsViewControllerProtocol

extension DocumentsViewController: DocumentsViewControllerProtocol {
  func updateUI(viewModel: DocumentsViewModel) {
    self.viewModel = viewModel
    navigationItem.title = viewModel.navigationTitleText
    setItems(items, animated: true)
  }
}
