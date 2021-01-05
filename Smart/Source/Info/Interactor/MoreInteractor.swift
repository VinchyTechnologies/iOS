//
//  MoreInteractor.swift
//  Coffee
//
//  Created by Алексей Смирнов on 10/04/2019.
//  Copyright © 2019 Алексей Смирнов. All rights reserved.
//
// swiftlint:disable all

import EmailService
import Core

final class MoreInteractor {
  
  var presenter: MorePresenterProtocol
  
  private let vkURL = "https://vk.com"
  
  private let emailService: EmailServiceProtocol = EmailService()
  private let router: MoreRouterProtocol
  
  init(presenter: MorePresenterProtocol, router: MoreRouterProtocol) {
    self.presenter = presenter
    self.router = router
  }
  
  private func openUrl(urlString: String) {
    open(urlString: urlString) {
      presenter.showOpenURLErrorAlert()
    }
  }
}

extension MoreInteractor: MoreInteractorProtocol {
  
  func viewDidLoad() {
    presenter.update(isRussianLocale: Locale.current.languageCode == "ru")
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

