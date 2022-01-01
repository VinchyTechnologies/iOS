//
//  StoresPresenter.swift
//  Smart
//
//  Created by Михаил Исаченко on 08.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import DisplayMini
import StringFormatting
import VinchyCore

// MARK: - StoresPresenter

final class StoresPresenter {

  // MARK: Lifecycle

  init(input: StoresInput, viewController: StoresViewControllerProtocol) {
    self.input = input
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: StoresViewControllerProtocol?

  // MARK: Private

  private let input: StoresInput

}

// MARK: StoresPresenterProtocol

extension StoresPresenter: StoresPresenterProtocol {

  func showNoSavedStores() {
    viewController?.updateUI(
      errorViewModel: ErrorViewModel(
        titleText: localized("nothing_here").firstLetterUppercased(),
        subtitleText: nil,
        buttonText: nil))
  }

  func update(partnersInfo: [PartnerInfo], needLoadMore: Bool) {

    var sections: [StoresViewModel.Section] = []

    var navigationTitleText: String

    switch input.mode {
    case .wine:
      navigationTitleText = localized("all_shops").firstLetterUppercased()

    case .saved:
      navigationTitleText = localized("saved_stores").firstLetterUppercased()
    }

    if !partnersInfo.isEmpty {
      sections += [.title(navigationTitleText)]

      let partnersContent: [StoresViewModel.PartnersContent] = partnersInfo.map({ partner in
        StoresViewModel.PartnersContent.horizontalPartner(.init(affiliatedStoreId: partner.affiliatedStoreId, imageURL: partner.logoURL, titleText: partner.title, subtitleText: partner.address))
      })

      sections += [.partners(content: partnersContent)]

      if needLoadMore {
        sections += [.loading(itemID: .loadingItem)]
      }
    }

    let viewModel = StoresViewModel(sections: sections, navigationTitleText: navigationTitleText)
    viewController?.updateUI(viewModel: viewModel)
  }

  func startLoading() {
    viewController?.addLoader()
    viewController?.startLoadingAnimation()
  }

  func stopLoading() {
    viewController?.stopLoadingAnimation()
  }

  func showErrorAlert(error: Error) {
    viewController?.showAlert(
      title: localized("error").firstLetterUppercased(),
      message: error.localizedDescription)
  }

  func showInitiallyLoadingError(error: Error) {
    viewController?.updateUI(
      errorViewModel: ErrorViewModel(
        titleText: localized("error").firstLetterUppercased(),
        subtitleText: error.localizedDescription,
        buttonText: localized("reload").firstLetterUppercased()))
  }
}
