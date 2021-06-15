//
//  MorePresenter.swift
//  Coffee
//
//  Created by Алексей Смирнов on 10/04/2019.
//  Copyright © 2019 Алексей Смирнов. All rights reserved.
//
// swiftlint:disable all

import CommonUI
import Core
import Display
import StringFormatting
import UIKit

let instagramURL = "https://www.instagram.com"
let openAppStoreURL = localized("appstore_link")

// MARK: - MorePresenter

final class MorePresenter {

  // MARK: Lifecycle

  // MARK: - Initializers

  init(viewController: MoreViewControllerProtocol) {
    self.viewController = viewController
  }

  // MARK: Internal

  // MARK: - Internal Properties

  weak var viewController: MoreViewControllerProtocol?

  // MARK: Private

  // MARK: - Private Methods

  private func createViewModel(isRussianLocale: Bool, currency: String) -> MoreViewControllerModel {
    var sections: [MoreViewControllerModel.Section] = []

    if UserDefaultsConfig.accountID != 0, UserDefaultsConfig.accountEmail != "" {
      let profileViewModel = ProfileCellViewModel(
        nameUser: UserDefaultsConfig.userName == "" ? "What's your name?" : UserDefaultsConfig.userName,
        emailUser: UserDefaultsConfig.accountEmail)
      sections.append(.profile([profileViewModel]))
      sections.append(.separator)
    }

    let headerViewModel = TextCollectionCellViewModel(
      titleText: .init(
        string: localized("always_available").firstLetterUppercased(),
        font: Font.bold(16),
        textColor: .blueGray))
    sections.append(.header([headerViewModel]))

    if isRussianLocale {
      let phoneViewModel = ContactCellViewModel(
        titleText: localized("contact_phone"),
        icon: UIImage(named: "phone"),
        detailText: localized("for_any_questions").firstLetterUppercased())
      sections.append(.phone([phoneViewModel]))
    }

    let emailViewModel = ContactCellViewModel(
      titleText: localized("contact_email"),
      icon: UIImage(systemName: "envelope.fill"),
      detailText: localized("email_us").firstLetterUppercased())
    sections.append(.email([emailViewModel]))

    let partnerViewModel = ContactCellViewModel(
      titleText: localized("looking_for_partners").firstLetterUppercased(),
      icon: UIImage(named: "job"),
      detailText: localized("become_a_part_of_a_wine_startup").firstLetterUppercased())
    sections.append(.partner([partnerViewModel]))

    let rateViewModel = RateAppCellViewModel(
      titleText: localized("rate_our_app").firstLetterUppercased(),
      emojiLabel: "👍")
    sections.append(.rate([rateViewModel]))

    let currencyViewModel = InfoCurrencyCellViewModel(
      titleText: localized("currency").firstLetterUppercased(),
      symbolText: currency,
      icon: UIImage(systemName: "creditcard.fill"))
    sections.append(.currency([currencyViewModel]))

    let docViewModel = DocCellViewModel(
      titleText: localized("legal_documents").firstLetterUppercased(),
      icon: UIImage(named: "document"))
    sections.append(.doc([docViewModel]))

    let aboutAppViewModel = DocCellViewModel(
      titleText: localized("about_the_app").firstLetterUppercased(),
      icon: UIImage(named: "info"))
    sections.append(.aboutApp([aboutAppViewModel]))

    return MoreViewControllerModel(
      sections: sections,
      navigationTitle: localized("info").firstLetterUppercased())
  }
}

// MARK: MorePresenterProtocol

extension MorePresenter: MorePresenterProtocol {
  var phoneURL: String {
    localized("contact_phone_url")
  }

  var sendEmailRecipients: [String] {
    [localized("contact_email")]
  }

  func showOpenURLErrorAlert() {
    viewController?.showAlertCantOpenURL()
  }

  func showAlertCantOpenEmail() {
    viewController?.showAlertCantOpenEmail()
  }

  func update(isRussianLocale: Bool, currency: String) {
    let viewModel = createViewModel(isRussianLocale: isRussianLocale, currency: currency)
    viewController?.updateUI(viewModel: viewModel)
  }
}
