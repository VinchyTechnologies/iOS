//
//  MoreInteractor.swift
//  Coffee
//
//  Created by Алексей Смирнов on 10/04/2019.
//  Copyright © 2019 Алексей Смирнов. All rights reserved.
//
// swiftlint:disable all

import Core
import StringFormatting

// MARK: - MoreInteractor

final class MoreInteractor {

  // MARK: Lifecycle

  init(presenter: MorePresenterProtocol, router: MoreRouterProtocol) {
    self.presenter = presenter
    self.router = router
  }

  // MARK: Internal

  var presenter: MorePresenterProtocol

  // MARK: Private

  private let vkURL = "https://vk.com"

  private let emailService: EmailServiceProtocol = EmailService()
  private let router: MoreRouterProtocol

  private func openUrl(urlString: String) {
    open(urlString: urlString) {
      presenter.showOpenURLErrorAlert()
    }
  }

  private func logout() {
    UserDefaultsConfig.accountEmail = ""
    UserDefaultsConfig.accountID = 0
    UserDefaultsConfig.userName = ""
    UserDefaultsConfig.appleUserId = ""
    Keychain.shared.accessToken = nil
    Keychain.shared.refreshToken = nil
    Keychain.shared.password = nil

    viewDidLoad()
  }
}

// MARK: MoreInteractorProtocol

extension MoreInteractor: MoreInteractorProtocol {

  func didTapLogoutOnAlert() {
    logout()
  }

  func didTapLogout() {
    router.presentAlertAreYouSureLogout(
      titleText: presenter.logoutAlertTitleText,
      subtitleText: presenter.logoutAlertSubtitleText,
      leadingButtonText: presenter.logoutAlretLeadingButtonText,
      trailingButtonText: presenter.logoutAlretTrailingButtonText)
  }

  func didTapProfile() {
    if UserDefaultsConfig.accountID != 0 {
      router.presentShowEditProfileViewController()
    } else {
      router.presentAuthorizationViewController()
    }
  }

  func didTapCurrency() {
    router.pushToCurrencyViewController()
  }

  func viewDidLoad() {
    let symbol = allCurrencies().first(where: ({ $0.code == UserDefaultsConfig.currency }))?.symbol ?? ""
    presenter.update(
      isRussianLocale: Locale.current.languageCode == "ru",
      currency: UserDefaultsConfig.currency + "-" + symbol)
  }

  func didTapRateApp() {
    openUrl(urlString: openAppStoreURL)
  }

  func didTapOpenVk() {
    openUrl(urlString: vkURL)
  }

  func didTapCallUs() {
    open(urlString: presenter.phoneURL) {
      presenter.showOpenURLErrorAlert()
    }
  }

  func didTapOpenInstagram() {
    openUrl(urlString: instagramURL)
  }

  func didTapAboutApp() {
    router.pushToAboutController()
  }

  func didTapDoc() {
    router.pushToDocController()
  }

  func didTapworkWithUs() {
    didTapSendEmail(HTMLText: nil)
  }

  func didTapEmailUs() {
    didTapSendEmail(HTMLText: nil)
  }

  func didTapSendEmail(HTMLText: String?) {
    if emailService.canSend {
      router.presentEmailController(HTMLText: HTMLText, recipients: presenter.sendEmailRecipients)
    } else {
      presenter.showAlertCantOpenEmail()
    }
  }
}
