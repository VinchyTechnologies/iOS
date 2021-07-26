//
//  SearchPresenter.swift
//  Smart
//
//  Created by Алексей Смирнов on 01.07.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

// MARK: - SearchPresenter

import StringFormatting

// MARK: - SearchPresenter

final class SearchPresenter {

  // MARK: Lifecycle

  init(viewController: SearchViewControllerProtocol) {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: SearchViewControllerProtocol?

  // MARK: Private

  private typealias ViewModel = SearchViewModel

}

// MARK: SearchPresenterProtocol

extension SearchPresenter: SearchPresenterProtocol {
  var cantFindWineText: String {
    localized("email_did_not_find_wine")
  }

  var cantFindWineRecipients: [String] {
    [localized("contact_email")]
  }

  func showAlertCantOpenEmail() {
    viewController?.showAlert(title: localized("error"), message: localized("open_mail_error"))
  }
}
