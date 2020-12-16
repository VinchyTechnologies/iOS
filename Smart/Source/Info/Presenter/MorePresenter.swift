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

    var ContactCell: [ContactCellViewModel] = []

    let phoneViewModel = ContactCellViewModel(
      titleText: localized("contact_phone"),
      icon: UIImage(named: "phone"),
      detailText: localized("for_any_questions").firstLetterUppercased())

//    if Locale.current.languageCode == "ru" {
//      ContactCell.append(contactPhoneViewModel)
//    }

    let contactEmailViewModel = ContactCellViewModel(
      titleText: localized("contact_email"),
      icon: UIImage(systemName: "envelope.fill"),
      detailText: localized("email_us").firstLetterUppercased())
    ContactCell.append(contactEmailViewModel)

    let jobViewModel = ContactCellViewModel(
      titleText: localized("looking_for_partners").firstLetterUppercased(),
      icon: UIImage(named: "job"),
      detailText: localized("become_a_part_of_a_wine_startup").firstLetterUppercased())
    ContactCell.append(jobViewModel)

    let rateViewModel = RateAppCellViewModel(
      titleText: localized("rate_our_app").firstLetterUppercased(),
      emojiLabel: "👍")

    let docViewModel = DocCellViewModel(
      titleText: localized("legal_documents").firstLetterUppercased(),
      icon: UIImage(named: "document"))

    let infoViewModel = DocCellViewModel(
      titleText: localized("about_the_app").firstLetterUppercased(),
      icon: UIImage(named: "info")?.withRenderingMode(.alwaysTemplate))

//    let rateSection = MoreViewControllerModel.Section
//    let docsSection = MoreViewControllerModel.Section.doc([docViewModel, infoViewModel])


    return MoreViewControllerModel(
      sections: [
        .header([headerViewModel]),
        .phone([phoneViewModel]),
        .rate([rateViewModel]),
//        docsSection
      ],
      navigationTitle: localized("info").firstLetterUppercased())
  }
  
  // MARK: - Lifecycle
  
  required init(view: MoreViewProtocol) {
    self.view = view
  }
  
  private func openUrl(urlString: String) {
    open(urlString: urlString) {
      view.showAlert(
        title: localized("error").firstLetterUppercased(),
        message: localized("open_url_error").firstLetterUppercased())
    }
  }
  
  private func sendEmail(with HTMLText: String?) {
    interactor.sendEmail(HTMLText: HTMLText)
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
