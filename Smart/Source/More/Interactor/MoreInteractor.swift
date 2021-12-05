//
//  MoreInteractor.swift
//  Coffee
//
//  Created by Алексей Смирнов on 10/04/2019.
//  Copyright © 2019 Алексей Смирнов. All rights reserved.
//
// swiftlint:disable all

import Core
import Database
import StringFormatting
import UIKit
import VinchyCore

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

  private let authService = AuthService.shared
  private let router: MoreRouterProtocol

  private func openUrl(urlString: String) {
    open(urlString: urlString) {
      presenter.showOpenURLErrorAlert()
    }
  }

  private func logout() {
    authService.logout()
    viewDidLoad()
    ratesRepository.state = .needsReload
  }

  private func didTapSendEmail(HTMLText: String?, includingThirdPartyApps: Bool, sourceView: UIView) {
    router.presentContactActionSheet(to: localized("contact_email"), subject: "", body: "", includingThirdPartyApps: includingThirdPartyApps, sourceView: sourceView)
  }
}

// MARK: MoreInteractorProtocol

extension MoreInteractor: MoreInteractorProtocol {

  func didTapOpenInstagram() {
    openUrl(urlString: localized("instagram_link"))
  }

  func didTapOpenTelegram() {
    openUrl(urlString: localized("telegram_link"))
  }

  func didTapOpenFacebook() {
    openUrl(urlString: localized("facebook_link"))
  }

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
    if authService.isAuthorized {
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

  func didTapCallUs() {
    open(urlString: presenter.phoneURL) {
      presenter.showOpenURLErrorAlert()
    }
  }

  func didTapAboutApp() {
    router.pushToAboutController()
  }

  func didTapDoc() {
    router.pushToDocController()
  }

  func didTapworkWithUs(sourceView: UIView) {
    didTapSendEmail(HTMLText: nil, includingThirdPartyApps: true, sourceView: sourceView)
  }

  func didTapEmailUs(sourceView: UIView) {
    didTapSendEmail(HTMLText: nil, includingThirdPartyApps: false, sourceView: sourceView)
  }
}
