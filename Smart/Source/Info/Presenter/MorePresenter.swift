//
//  MorePresenter.swift
//  Coffee
//
//  Created by Алексей Смирнов on 10/04/2019.
//  Copyright © 2019 Алексей Смирнов. All rights reserved.
//
// swiftlint:disable all

import UIKit
import Core
import StringFormatting
import CommonUI
import Display

let vkURL = "https://vk.com"
let instagramURL = "https://www.instagram.com"
let openAppStoreURL = localized("appstore_link")

final class MorePresenter {
  
  // MARK: - Properties
  
  weak var view: MoreViewProtocol!
  var interactor: MoreInteractorProtocol!
  var router: MoreRouterProtocol!

  func createViewModel() -> MoreViewControllerModel  {

    let headerViewModel = TextCollectionCellViewModel(
      titleText: .init(string: localized("always_available").firstLetterUppercased(),
                       font: Font.bold(16),
                       textColor: .blueGray))

    let phoneViewModel = ContactCellViewModel(
      titleText: localized("contact_phone"),
      icon: UIImage(named: "phone"),
      detailText: localized("for_any_questions").firstLetterUppercased())

    let emailViewModel = ContactCellViewModel(
      titleText: localized("contact_email"),
      icon: UIImage(systemName: "envelope.fill"),
      detailText: localized("email_us").firstLetterUppercased())

    let jobViewModel = ContactCellViewModel(
      titleText: localized("looking_for_partners").firstLetterUppercased(),
      icon: UIImage(named: "job"),
      detailText: localized("become_a_part_of_a_wine_startup").firstLetterUppercased())

    let rateViewModel = RateAppCellViewModel(
      titleText: localized("rate_our_app").firstLetterUppercased(),
      emojiLabel: "👍")

    let docViewModel = DocCellViewModel(
      titleText: localized("legal_documents").firstLetterUppercased(),
      icon: UIImage(named: "document"))

    let aboutAppViewModel = DocCellViewModel(
      titleText: localized("about_the_app").firstLetterUppercased(),
      icon: UIImage(named: "info")?.withRenderingMode(.alwaysTemplate))

    return MoreViewControllerModel(
      sections: [
        .header([headerViewModel]),
        .phone([phoneViewModel]),
        .email([emailViewModel]),
        .partner([jobViewModel]),
        .rate([rateViewModel]),
        .doc([docViewModel]),
        .aboutApp([aboutAppViewModel])
      ],
      navigationTitle: localized("info").firstLetterUppercased())
  }
  
  // MARK: - Lifecycle
  
  required init(viewController: MoreViewProtocol) {
    self.view = viewController
  }
  
  private func didTapOpenUrl(urlString: String) {
    open(urlString: urlString) {
      view.showAlert(
        title: localized("error").firstLetterUppercased(),
        message: localized("open_url_error").firstLetterUppercased())
    }
  }
  
  private func didTapSendEmail(with HTMLText: String?) {
    interactor.didTapSendEmail(HTMLText: HTMLText)
  }
}

extension MorePresenter: MorePresenterProtocol {
  
  func startCreateViewModel() {
    view.updateUI(viewModel: createViewModel())
  }
  
  func showAlert(message: String) {
    view.showAlert(
      title: localized("error").firstLetterUppercased(),
      message: message)
  }
  
  func present(controller: UIViewController, completion: (() -> Void)?) {
    router.present(controller, completion: nil)
  }
}
