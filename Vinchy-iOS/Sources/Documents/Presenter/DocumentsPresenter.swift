//
//  DocumentsPresenter.swift
//  Smart
//
//  Created by Алексей Смирнов on 04.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import StringFormatting

// MARK: - DocumentsPresenter

final class DocumentsPresenter {

  // MARK: Lifecycle

  init(viewController: DocumentsViewControllerProtocol) {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: DocumentsViewControllerProtocol?
}

// MARK: DocumentsPresenterProtocol

extension DocumentsPresenter: DocumentsPresenterProtocol {

  func showAlertCantOpenURL() {
    viewController?.showAlertCantOpenURL()
  }

  func update(documents: [Document]) {
    let sections = documents.compactMap { document in
      DocumentsViewModel.Section.urlDocument(.init(id: document.id, title: document.title, body: nil))
    }
    let viewModel = DocumentsViewModel(
      sections: sections,
      navigationTitleText: localized("legal_documents").firstLetterUppercased())
    viewController?.updateUI(viewModel: viewModel)
  }
}
