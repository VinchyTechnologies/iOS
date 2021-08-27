//
//  SearchInteractor.swift
//  Smart
//
//  Created by Алексей Смирнов on 01.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import Core

// MARK: - SearchInteractor

final class SearchInteractor {

  // MARK: Lifecycle

  init(
    router: SearchRouterProtocol,
    presenter: SearchPresenterProtocol)
  {
    self.router = router
    self.presenter = presenter
  }

  // MARK: Private

  private let router: SearchRouterProtocol
  private let presenter: SearchPresenterProtocol
  private let emailService = EmailService()

}

// MARK: SearchInteractorProtocol

extension SearchInteractor: SearchInteractorProtocol {
  func didTapDidnotFindWineFromSearch(searchText: String?) {
    guard let searchText = searchText else {
      return
    }

    if emailService.canSend {
      router.presentEmailController(
        HTMLText: presenter.cantFindWineText + searchText,
        recipients: presenter.cantFindWineRecipients)
    } else {
      presenter.showAlertCantOpenEmail()
    }
  }
}
