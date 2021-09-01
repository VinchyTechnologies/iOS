//
//  StoresPresenter.swift
//  Smart
//
//  Created by Михаил Исаченко on 08.08.2021.
//  Copyright © 2021 Aleksei Smirnov. All rights reserved.
//

import CommonUI
import StringFormatting
import VinchyCore

// MARK: - StoresPresenter

final class StoresPresenter {

  // MARK: Lifecycle

  init(viewController: StoresViewControllerProtocol) {
    self.viewController = viewController
  }

  // MARK: Internal

  weak var viewController: StoresViewControllerProtocol?

  // MARK: Private

  private typealias ViewModel = StoresViewModel
}

// MARK: StoresPresenterProtocol

extension StoresPresenter: StoresPresenterProtocol {

  func update(partnersInfo: [PartnerInfo], needLoadMore: Bool) {

    var sections: [StoresViewModel.Section] = []

    if !partnersInfo.isEmpty {
      sections += [.title(localized("all_shops").firstLetterUppercased())]

      let partnersContent: [StoresViewModel.PartnersContent] = partnersInfo.map({ partner in
        StoresViewModel.PartnersContent.horizontalPartner(.init(affiliatedStoreId: partner.affiliatedStoreId, imageURL: partner.logoURL?.toURL, titleText: partner.title, subtitleText: partner.address, scheduleOfWorkText: partner.scheduleOfWork))
      })

      sections += [.partners(content: partnersContent)]

      if needLoadMore {
        sections += [.loading(itemID: .loadingItem)]
      }
    }

    let viewModel = StoresViewModel(sections: sections, navigationTitleText: localized("all_shops").firstLetterUppercased())
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
