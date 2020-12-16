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

let vkURL = "https://vk.com"
let instagramURL = "https://www.instagram.com"
let openAppStoreURL = localized("appstore_link")

final class MorePresenter: OpenURLProtocol {
  
  // MARK: - Properties
  
  weak var view: MoreViewProtocol!
  var interactor: MoreInteractorProtocol!
  var router: MoreRouterProtocol!

  func createViewModel() -> MoreViewControllerModel  {
    let headerViewModel = HeaderCellViewModel(
      titleText: localized("always_available").firstLetterUppercased())
    var ContactCell: [ContactCellViewModel] = []
    let contactPhoneViewModel = ContactCellViewModel(
      titleText: localized("contact_phone"),
      icon: UIImage(named: "phone"),
      detailText: localized("for_any_questions").firstLetterUppercased())
    if Locale.current.languageCode == "ru" {
      ContactCell.append(contactPhoneViewModel)
    }
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
    
    let headerSection = MoreViewControllerModel.Section.header([headerViewModel])
    let contactsSection = MoreViewControllerModel.Section.contact(ContactCell)
    let rateSection = MoreViewControllerModel.Section.rate([rateViewModel])
    let docsSection = MoreViewControllerModel.Section.doc([docViewModel, infoViewModel])
    return MoreViewControllerModel(sections: [headerSection, contactsSection, rateSection, docsSection])
  }
  
  // MARK: - Lifecycle
  
  required init(view: MoreViewProtocol) {
    self.view = view
  }
  
  private func openUrl(urlString: String) {
    open(urlString: urlString) {
      view.presentAlert(message: localized("open_url_error"))
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
    view.presentAlert(message: message)
  }
  
  func present(controller: UIViewController, completion: (() -> Void)?) {
    router.present(controller, completion: nil)
  }
}
