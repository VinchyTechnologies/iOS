//
//  DocumentsInteractor.swift
//  Smart
//
//  Created by Алексей Смирнов on 04.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

// MARK: - DocumentsInteractor

final class DocumentsInteractor {

  // MARK: Lifecycle

  init(
    router: DocumentsRouterProtocol,
    presenter: DocumentsPresenterProtocol)
  {
    self.router = router
    self.presenter = presenter
  }

  // MARK: Private

  private let router: DocumentsRouterProtocol
  private let presenter: DocumentsPresenterProtocol

}

// MARK: DocumentsInteractorProtocol

extension DocumentsInteractor: DocumentsInteractorProtocol {

  func viewDidLoad() {
    presenter.update(documents: Document.allCases)
  }

  func didSelectDocument(documentId: Int) {
    if let document = Document.allCases.first(where: { $0.id == documentId }) {
      router.open(urlString: document.url) {
//        presenter.
      }
    }
  }
}
